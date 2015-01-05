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

const float scaleUpAnimateDuration = .8;

@interface RGSContactDetailHandler ()
@property UIButton *chatContactButton;
@property UIButton *deleteContactButton;
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
    
    CGRect thumbnailImageRect = [contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view];
    NSLog(@"rect:%@", NSStringFromCGRect(thumbnailImageRect));
    
    float scalingFactor = 1.6;
    
    
    CGAffineTransform t = CGAffineTransformMakeScale(scalingFactor, scalingFactor);
    CGRect scaledRect = [self scaleRect:thumbnailImageRect withTrasformation:t];
    
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailImageRect];
    thumbnailImageView.image = contactCell.thumbnailImageView.image;
    thumbnailImageView.layer.cornerRadius = 10;
    thumbnailImageView.layer.masksToBounds = YES;
    
    [contactListViewController.view addSubview:thumbnailImageView];
    
    
    
    
    
    
    self.chatContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatContactButton.frame = CGRectMake(CGRectGetMaxX(scaledRect) + 5, CGRectGetMinY(scaledRect) + 5, 40, 40);
    self.chatContactButton.backgroundColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    [self.chatContactButton setImage:[[UIImage imageNamed:@"chat_Contact"] resizedImage:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    self.chatContactButton.alpha = 0;
    self.chatContactButton.layer.cornerRadius = 10;
    
    self.deleteContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteContactButton.frame = CGRectMake(CGRectGetMaxX(scaledRect) + 5, CGRectGetMaxY(self.chatContactButton.frame) + 5, 40, 40);
    self.deleteContactButton.backgroundColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    [self.deleteContactButton setImage:[[UIImage imageNamed:@"delete_Contact"] resizedImage:CGSizeMake(12, 12)] forState:UIControlStateNormal];
    self.deleteContactButton.alpha = 0;
    self.deleteContactButton.layer.cornerRadius = 10;
    
    [contactListViewController.view addSubview:self.deleteContactButton];
    [contactListViewController.view addSubview:self.chatContactButton];

    if(CGRectContainsRect([UIScreen mainScreen].bounds, scaledRect)){
        NSLog(@"scaled Rect is inside mainScreen");
        
        [UIView animateWithDuration:scaleUpAnimateDuration animations:^{
            thumbnailImageView.transform = t;
        }];
        
        [self animateDetailButtons];
        

    } else {
        NSLog(@"scaled Rect is NOT inside mainScreen");
        int padding = 8;
        
        CGAffineTransform translation;

        CGRect chatButtonFrame = self.chatContactButton.frame;
        CGRect deleteButtonFrame = self.deleteContactButton.frame;
        
        if(CGRectGetMinX(scaledRect) < 0.0f){
            float rightShift = padding -(CGRectGetMinX(scaledRect));
            
            translation = CGAffineTransformMakeTranslation(rightShift, padding);
            
            
            chatButtonFrame.origin.x += rightShift;
            chatButtonFrame.origin.y += padding;
            self.chatContactButton.frame = chatButtonFrame;
            
            deleteButtonFrame.origin.x += rightShift;
            deleteButtonFrame.origin.y += padding;
            self.deleteContactButton.frame = deleteButtonFrame;
            
        } else {
            float leftShift = -(CGRectGetMaxX(scaledRect) - CGRectGetWidth([UIScreen mainScreen].bounds) + padding);
            
            translation = CGAffineTransformMakeTranslation(leftShift, padding);
            
            chatButtonFrame.origin.x = (CGRectGetMinX(scaledRect)+leftShift) - (padding + CGRectGetWidth(self.chatContactButton.frame));
            chatButtonFrame.origin.y = CGRectGetMinY(scaledRect) + 5 + padding;
            self.chatContactButton.frame = chatButtonFrame;
            
            
            deleteButtonFrame.origin.x = chatButtonFrame.origin.x;
            deleteButtonFrame.origin.y = CGRectGetMaxY(chatButtonFrame) + 5;
            self.deleteContactButton.frame = deleteButtonFrame;
        }
        
        CGAffineTransform translationWithScaling = CGAffineTransformScale(translation, scalingFactor, scalingFactor);
        [UIView animateWithDuration:scaleUpAnimateDuration animations:^{
            thumbnailImageView.transform = translationWithScaling;
        }];
        
        [self animateDetailButtons];
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

@end
