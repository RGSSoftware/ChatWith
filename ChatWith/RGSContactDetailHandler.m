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

const BOOL isLeftOffScreen(CGRect rect){
    return CGRectGetMinX(rect) < 0.0f;
}

BOOL isBottomOffScreen(CGRect rect){
    return CGRectGetMaxY(rect) > CGRectGetMaxY([UIScreen mainScreen].bounds);
}

BOOL isWithinScreenBounds(CGRect rect){
    return CGRectContainsRect([UIScreen mainScreen].bounds, rect);
}

const float scaleUpAnimateDuration = .6;
const float topDetailButtonPadding = 5;
const float sideDetailButtonPadding = 5;

const float scalingFactor = 1.6;

@interface RGSContactDetailHandler ()
@property UIButton *chatContactButton;
@property UIButton *deleteContactButton;

@property UIImageView *thumbnailImageView;
@end


@implementation RGSContactDetailHandler
- (void)animateDetailButtons {
    [UIView animateWithDuration:(scaleUpAnimateDuration -.3) delay:.2 options:UIViewAnimationOptionCurveLinear animations:^{
        self.chatContactButton.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:(scaleUpAnimateDuration -.5) delay:.4 options:UIViewAnimationOptionCurveLinear animations:^{
        self.deleteContactButton.alpha = 1;
    } completion:nil];
}

-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContactAtIndex:(NSIndexPath *)contactIndex{
    RGSContactCell *contactCell = [contactListViewController contactCellAtIndex:contactIndex];
    
    CGRect contactCellRect = [contactListViewController.collectionView convertRect:contactCell.frame toView:contactListViewController.view];
    if(!isBottomOffScreen(contactCellRect)){
        
        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        UIView *dimView = [[UIView alloc] initWithFrame:contactListViewController.view.frame];
        dimView.backgroundColor = [UIColor blackColor];
        dimView.alpha = 0;
        [dimView bk_whenTapped:^{
            [UIView animateWithDuration:scaleUpAnimateDuration - .4 animations:^{
                self.thumbnailImageView.transform = CGAffineTransformScale(self.thumbnailImageView.transform, .6, .6);
                
                dimView.alpha = 0;
                
                self.chatContactButton.alpha = 0;
                self.deleteContactButton.alpha = 0;
            } completion:^(BOOL finished) {
                if(finished){
                    [self.thumbnailImageView removeFromSuperview];
                    [self.chatContactButton removeFromSuperview];
                    [self.deleteContactButton removeFromSuperview];
                    [dimView removeFromSuperview];
                }
            }];
            
        }];
        [mainWindow addSubview:dimView];
        [UIView animateWithDuration:scaleUpAnimateDuration animations:^{
            dimView.alpha = .21;
        }];
        
        CGRect thumbnailImageRect = [contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view];
        
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailImageRect];
        self.thumbnailImageView.image = contactCell.thumbnailImageView.image;
        self.thumbnailImageView.layer.cornerRadius = 10;
        self.thumbnailImageView.layer.masksToBounds = YES;
        [mainWindow addSubview:self.thumbnailImageView];
        
        
        self.chatContactButton = [self detailContactButtonWithImage:[[UIImage imageNamed:@"chat_Contact"] resizedImage:CGSizeMake(20, 20)]];
        [mainWindow addSubview:self.chatContactButton];
        [self.chatContactButton bk_addEventHandler:^(id sender) {
            [UIView animateWithDuration:scaleUpAnimateDuration - .4 animations:^{
                self.thumbnailImageView.transform = CGAffineTransformScale(self.thumbnailImageView.transform, .6, .6);
                
                dimView.alpha = 0;
                
                self.chatContactButton.alpha = 0;
                self.deleteContactButton.alpha = 0;
            } completion:^(BOOL finished) {
                if(finished){
                    [self.thumbnailImageView removeFromSuperview];
                    [self.chatContactButton removeFromSuperview];
                    [self.deleteContactButton removeFromSuperview];
                    [dimView removeFromSuperview];
                    
                    [contactListViewController performSegueWithIdentifier:@"toMessagesScreen" sender:contactCell];
                }
            }];

        } forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteContactButton = [self detailContactButtonWithImage:[[UIImage imageNamed:@"delete_Contact"] resizedImage:CGSizeMake(12, 12)]];
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
            
            [UIView animateWithDuration:scaleUpAnimateDuration animations:^{
                self.thumbnailImageView.transform = scalingTransformation;
            }];
            
            [self animateDetailButtons];
            
            
        } else {
            //else scaled Rect is NOT inside mainScreen bounds
            int padding = 8;
            
            CGAffineTransform translation;
            
            CGRect chatButtonFrame = self.chatContactButton.frame;
            CGRect deleteButtonFrame = self.deleteContactButton.frame;
            
            if(isLeftOffScreen(scaledRect)){
                float rightShift = padding -(CGRectGetMinX(scaledRect));
                
                translation = CGAffineTransformMakeTranslation(rightShift, padding);
                
                chatButtonFrame.origin.x = CGRectGetMaxX(scaledRect) + sideDetailButtonPadding + rightShift;
                chatButtonFrame.origin.y = CGRectGetMinY(scaledRect) + topDetailButtonPadding + padding;
                self.chatContactButton.frame = chatButtonFrame;
                
                deleteButtonFrame.origin.x = CGRectGetMaxX(scaledRect) + sideDetailButtonPadding + rightShift;
                deleteButtonFrame.origin.y = CGRectGetMaxY(chatButtonFrame) + topDetailButtonPadding;
                self.deleteContactButton.frame = deleteButtonFrame;
                
            } else {
                //else right off screen
                float leftShift = -(CGRectGetMaxX(scaledRect) - CGRectGetWidth([UIScreen mainScreen].bounds) + padding);
                
                translation = CGAffineTransformMakeTranslation(leftShift, padding);
                
                chatButtonFrame.origin.x = (CGRectGetMinX(scaledRect)+leftShift) - (sideDetailButtonPadding + CGRectGetWidth(self.chatContactButton.frame));
                chatButtonFrame.origin.y = CGRectGetMinY(scaledRect) + topDetailButtonPadding + padding;
                self.chatContactButton.frame = chatButtonFrame;
                
                
                deleteButtonFrame.origin.x = chatButtonFrame.origin.x;
                deleteButtonFrame.origin.y = CGRectGetMaxY(chatButtonFrame) + topDetailButtonPadding;
                self.deleteContactButton.frame = deleteButtonFrame;
            }
            
            CGAffineTransform translationWithScaling = CGAffineTransformScale(translation, scalingFactor, scalingFactor);
            [UIView animateWithDuration:scaleUpAnimateDuration animations:^{
                self.thumbnailImageView.transform = translationWithScaling;
            }];
            
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

@end
