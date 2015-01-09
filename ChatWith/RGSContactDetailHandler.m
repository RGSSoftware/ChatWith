//
//  RGSContactDetailHandler.m
//  ChatWith
//
//  Created by PC on 12/30/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactDetailHandler.h"
#import "RGSContactCell.h"
#import "RGSContact.h"
#import "RGSManagedUser.h"

#import "UIImage+Resize.h"
#import "UIView+RGSFrame.h"
#import "UIView+RGSGesture.h"

const BOOL isLeftOffScreen(CGRect rect){
    return CGRectGetMinX(rect) < 0.0f;
}

BOOL isBottomOffScreen(CGRect rect){
    return CGRectGetMaxY(rect) > CGRectGetMaxY([UIScreen mainScreen].bounds);
}

BOOL isWithinScreenBounds(CGRect rect){
    return CGRectContainsRect([UIScreen mainScreen].bounds, rect);
}

const float scaleUpAnimationDuration = .6;

const float topDetailButtonPadding = 5;
const float sideDetailButtonPadding = 5;

const float showConfirmationViewAnimationDuration = .4;
const int CB_Width = 48;
int paddingBetweenCB = 8;
int CBs_BottomPadding = 20;
int CB_LeftPadding = 16;

const float scalingFactor = 1.6;

@interface RGSContactDetailHandler ()
@property UIButton *chatContactButton;
@property UIButton *deleteContactButton;

@property UIImageView *thumbnailImageView;

@property UIView *dimView;

@property UIView *confirmationView;

@property CGAffineTransform dissmissTransformation;

@property float offset;

@property RGSContactListViewController *contactListViewController;
@end


@implementation RGSContactDetailHandler
- (void)animateDetailButtons {
    [UIView animateWithDuration:(scaleUpAnimationDuration -.3) delay:.2 options:UIViewAnimationOptionCurveLinear animations:^{
        self.chatContactButton.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:(scaleUpAnimationDuration -.5) delay:.4 options:UIViewAnimationOptionCurveLinear animations:^{
        self.deleteContactButton.alpha = 1;
    } completion:nil];
}

-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContactAtIndex:(NSIndexPath *)contactIndex{
    self.contactListViewController = contactListViewController;
    RGSContactCell *contactCell = [contactListViewController contactCellAtIndex:contactIndex];
    
    CGRect contactCellRect = [contactListViewController.collectionView convertRect:contactCell.frame toView:contactListViewController.view];
    if(!isBottomOffScreen(contactCellRect)){
        
        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        self.dimView = [[UIView alloc] initWithFrame:contactListViewController.view.frame];
        self.dimView.backgroundColor = [UIColor blackColor];
        self.dimView.alpha = 0;
        [self.dimView bk_whenTapped:^{
            [self dismissOverlayWithCompletion:nil];
            
        }];
        [mainWindow addSubview:self.dimView];
        [UIView animateWithDuration:scaleUpAnimationDuration animations:^{
            self.dimView.alpha = .21;
        }];
        
        CGRect thumbnailImageRect = [contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view];
        
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailImageRect];
        self.thumbnailImageView.image = contactCell.thumbnailImageView.image;
        self.thumbnailImageView.layer.cornerRadius = 10;
        self.thumbnailImageView.layer.masksToBounds = YES;
        [mainWindow addSubview:self.thumbnailImageView];
        
        
        self.chatContactButton = [self detailContactButtonWithImage:[[UIImage imageNamed:@"chat_Contact"] resizedImage:CGSizeMake(20, 20)]];
        [self.chatContactButton bk_addEventHandler:^(id sender) {
            [self dismissOverlayWithCompletion:^(BOOL finished) {
                if(finished)[contactListViewController performSegueWithIdentifier:@"toMessagesScreen" sender:contactCell];
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        [mainWindow addSubview:self.chatContactButton];
        
        
        self.deleteContactButton = [self detailContactButtonWithImage:[[UIImage imageNamed:@"delete_Contact"] resizedImage:CGSizeMake(12, 12)]];
        [self.deleteContactButton bk_addEventHandler:^(id sender) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.deleteContactButton setHighlighted:YES];
                
                [self.chatContactButton setHighlighted:YES];
            });
            
            UIButton *deleteConButon = [self confirmationButtonWithTitle:@"Delete Contact"];
            [deleteConButon setFrameOriginY:CGRectGetMaxY([UIScreen mainScreen].bounds) - CBs_BottomPadding - (CB_Width * 2) - paddingBetweenCB];
            [deleteConButon setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            UIButton *cancelConButton = [self confirmationButtonWithTitle:@"Cancel"];
            [cancelConButton setFrameOriginY:CGRectGetMaxY([UIScreen mainScreen].bounds) - CBs_BottomPadding - CB_Width];
            
            self.confirmationView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.confirmationView setFrameOriginY:CBs_BottomPadding + (CB_Width * 2) + paddingBetweenCB];
            self.confirmationView.backgroundColor = [UIColor clearColor];
            
            
            [self.confirmationView bk_whenTapped:^{
                [self dismissConfirmationView];
            }];
            
            [cancelConButton bk_addEventHandler:^(id sender) {
                [self dismissConfirmationView];
            } forControlEvents:UIControlEventTouchUpInside];
            
            [deleteConButon bk_addEventHandler:^(id sender) {
                [self dismissConfirmationView];
                [self dismissOverlayWithCompletion:^(BOOL finished) {
                    if(finished){
                        [contactListViewController deleteContactAtIndex:contactIndex];
                    }
                }];
            } forControlEvents:UIControlEventTouchUpInside];
            [self.confirmationView addSubview:deleteConButon];
            [self.confirmationView addSubview:cancelConButton];
            [mainWindow addSubview:self.confirmationView];
            
            self.offset = 0;
            if (CGRectGetMaxY(self.thumbnailImageView.frame) >= CGRectGetMinY(deleteConButon.frame)) {
                
                self.offset = (CGRectGetMaxY(self.thumbnailImageView.frame) - CGRectGetMinY(deleteConButon.frame)) + 10;
                UIEdgeInsets inset = UIEdgeInsetsMake(self.offset, 0, 0, 0);
                contactListViewController.collectionView.contentInset = inset;
                
                CGPoint contentOffSet = contactListViewController.collectionView.contentOffset;
                contentOffSet.y += self.offset;
                
                [UIView animateWithDuration:showConfirmationViewAnimationDuration animations:^{
                    [self.thumbnailImageView setFrameOriginY:CGRectGetMinY(self.thumbnailImageView.frame) - self.offset];
                    [self.chatContactButton setFrameOriginY:CGRectGetMinY(self.chatContactButton.frame) - self.offset];
                    [self.deleteContactButton setFrameOriginY:CGRectGetMinY(self.deleteContactButton.frame) - self.offset];
                    
                    [contactListViewController.collectionView setContentOffset:contentOffSet animated:NO];
                    
                    [self.confirmationView setFrameOriginY:0];
                }];
                
            } else {
                [UIView animateWithDuration:showConfirmationViewAnimationDuration animations:^{
                    [self.confirmationView setFrameOriginY:0];
                }];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        [mainWindow addSubview:self.deleteContactButton];
        
        
        CGAffineTransform scalingTransformation = CGAffineTransformMakeScale(scalingFactor, scalingFactor);
        CGRect scaledRect = [self scaleRect:thumbnailImageRect withTrasformation:scalingTransformation];
        
        if(isWithinScreenBounds(scaledRect)){
            //scaled Rect is inside mainScreen bounds
            
            CGRect chatButtonFrame = self.chatContactButton.frame;
            chatButtonFrame.origin.x = CGRectGetMaxX(scaledRect) + sideDetailButtonPadding;
            chatButtonFrame.origin.y = CGRectGetMinY(scaledRect) + topDetailButtonPadding;
            self.chatContactButton.frame = chatButtonFrame;
            
            CGRect deleteButtonFrame = self.deleteContactButton.frame;
            deleteButtonFrame.origin.x = CGRectGetMaxX(scaledRect) + sideDetailButtonPadding;
            deleteButtonFrame.origin.y = CGRectGetMaxY(self.chatContactButton.frame) + topDetailButtonPadding;
            self.deleteContactButton.frame = deleteButtonFrame;
            
            [UIView animateWithDuration:scaleUpAnimationDuration animations:^{
                self.thumbnailImageView.transform = scalingTransformation;
            }];
            
            self.dissmissTransformation = CGAffineTransformScale(self.thumbnailImageView.transform, .6, .6);
            
            [self animateDetailButtons];
            
            
        } else {
            //else scaled Rect is NOT inside mainScreen bounds
            int padding = 8;
            
            CGAffineTransform translation;
            
            if(isLeftOffScreen(scaledRect)){
                float rightShift = padding -(CGRectGetMinX(scaledRect));
                
                translation = CGAffineTransformMakeTranslation(rightShift, padding);
                
                [self.chatContactButton setFrameOriginX:CGRectGetMaxX(scaledRect) + sideDetailButtonPadding + rightShift];
                [self.chatContactButton setFrameOriginY:CGRectGetMinY(scaledRect) + topDetailButtonPadding + padding];

                [self.deleteContactButton setFrameOriginX:CGRectGetMaxX(scaledRect) + sideDetailButtonPadding + rightShift];
                [self.deleteContactButton setFrameOriginY:CGRectGetMaxY(self.chatContactButton.frame) + topDetailButtonPadding];
                
            } else {
                //else right off screen
                float leftShift = -(CGRectGetMaxX(scaledRect) - CGRectGetWidth([UIScreen mainScreen].bounds) + padding);
                
                translation = CGAffineTransformMakeTranslation(leftShift, padding);
                
                [self.chatContactButton setFrameOriginX:(CGRectGetMinX(scaledRect)+leftShift) - (sideDetailButtonPadding + CGRectGetWidth(self.chatContactButton.frame))];
                [self.chatContactButton setFrameOriginY:CGRectGetMinY(scaledRect) + topDetailButtonPadding + padding];
                
                [self.deleteContactButton setFrameOriginX:CGRectGetMinX(self.chatContactButton.frame)];
                [self.deleteContactButton setFrameOriginY:CGRectGetMaxY(self.chatContactButton.frame) + topDetailButtonPadding];
            }
            
            CGAffineTransform translationWithScaling = CGAffineTransformScale(translation, scalingFactor, scalingFactor);
            [UIView animateWithDuration:scaleUpAnimationDuration animations:^{
                self.thumbnailImageView.transform = translationWithScaling;
            }];
            
            self.dissmissTransformation = CGAffineTransformScale(CGAffineTransformMakeTranslation(.5, .5), 1, 1);
            
            [self animateDetailButtons];
        }

        
    } else {
       CGPoint contentOffSet = contactListViewController.collectionView.contentOffset;
        contentOffSet.y += CGRectGetHeight(contactCell.frame) - 4;
        
        [UIView animateWithDuration:.1 animations:^{
            [contactListViewController.collectionView setContentOffset:contentOffSet animated:NO];
        } completion:^(BOOL finished) {
            if(finished) [self contactListViewController:contactListViewController didSelectContactAtIndex:contactIndex];
        }];
        return;
    }
}

-(CGRect)scaleRect:(CGRect)rect withTrasformation:(CGAffineTransform)t{
    float x = CGRectGetMinX(rect);
    float y = CGRectGetMinY(rect);
    float centerX = CGRectGetMaxX(rect) - (CGRectGetWidth(rect)/2);
    float centerY = CGRectGetMaxY(rect) - (CGRectGetHeight(rect)/2);
    
    float scaledX = ((x + -centerX) * t.a) + centerX;
    float scaledY = ((y + -centerY) * t.d) + centerY;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.origin.x = scaledX;
    scaledRect.origin.y = scaledY;
    scaledRect.size = CGSizeApplyAffineTransform(rect.size, t);
    return scaledRect;
}

-(UIButton *)detailContactButtonWithImage:(UIImage *)image{
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake(0,
                                    0,
                                    40,
                                    40);
    detailButton.backgroundColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    [detailButton setImage:image forState:UIControlStateNormal];
    detailButton.alpha = 0;
    detailButton.layer.cornerRadius = 10;
    
    return detailButton;
}

-(UIButton *)confirmationButtonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrameSizeWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - (CB_LeftPadding * 2)];
    [button setFrameSizeHeight:CB_Width];
    [button setFrameOriginX:CB_LeftPadding];
    button.backgroundColor = [UIColor colorWithWhite:0.849 alpha:1.000];
    button.alpha = .75;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 10;
    return button;

}

-(void)dismissOverlayWithCompletion:(void (^)(BOOL finished))completionFinished{
    [UIView animateWithDuration:scaleUpAnimationDuration - .4 animations:^{
        self.thumbnailImageView.transform = self.dissmissTransformation;
        self.dimView.alpha = 0;
        
        self.chatContactButton.alpha = 0;
        self.deleteContactButton.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [self.thumbnailImageView removeFromSuperview];
            [self.chatContactButton removeFromSuperview];
            [self.deleteContactButton removeFromSuperview];
            [self.dimView removeFromSuperview];
            if(completionFinished != nil) completionFinished(YES);
            
        } else {if(completionFinished != nil) completionFinished(NO);}
    }];
}

-(void)dismissConfirmationView{
    [self.deleteContactButton setHighlighted:NO];
    [self.chatContactButton setHighlighted:NO];
    
    float dismissConfirmationViewAnimationDuration = showConfirmationViewAnimationDuration - .1;
    
    float confirmationViewFinalY = (CBs_BottomPadding + (CB_Width * 2) + paddingBetweenCB + 10);
    
    if(self.offset > 0){
        CGPoint contentOffSet = self.contactListViewController.collectionView.contentOffset;
        contentOffSet.y -= self.offset;
        
        [UIView animateWithDuration:dismissConfirmationViewAnimationDuration animations:^{
            [self.thumbnailImageView setFrameOriginY:CGRectGetMinY(self.thumbnailImageView.frame) + self.offset];
            [self.chatContactButton setFrameOriginY:CGRectGetMinY(self.chatContactButton.frame) + self.offset];
            [self.deleteContactButton setFrameOriginY:CGRectGetMinY(self.deleteContactButton.frame) + self.offset];
            
            [self.contactListViewController.collectionView setContentOffset:contentOffSet animated:NO];
            
            [self.confirmationView setFrameOriginY:confirmationViewFinalY];
        } completion:^(BOOL finished) {
            if (finished) {
                self.contactListViewController.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
                [self.confirmationView removeFromSuperview];
            }
        }];

    } else {
        [UIView animateWithDuration:dismissConfirmationViewAnimationDuration animations:^{
            [self.confirmationView setFrameOriginY:confirmationViewFinalY];
        } completion:^(BOOL finished) {
            if(finished){
                [self.confirmationView removeFromSuperview];
            }
        }];
    }
}

@end
