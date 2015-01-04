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


@implementation RGSContactDetailHandler
-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContactAtIndex:(NSIndexPath *)contactIndex{
    RGSContactCell *contactCell = [contactListViewController contactCellAtIndex:contactIndex];
    
    NSLog(@"contactCell.thumbnailImageView.frame:%@", NSStringFromCGRect([contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view]));
    
    NSLog(@"screen rect:%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    

    CGRect thumbnailImageRect = [contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view];
    
    float scalingFactor = 1.6;
    
    
    CGAffineTransform t = CGAffineTransformMakeScale(scalingFactor, scalingFactor);
    CGRect scaledRect = [self scaleRect:thumbnailImageRect withTrasformation:t];
    
    
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailImageRect];
    thumbnailImageView.image = contactCell.thumbnailImageView.image;
    thumbnailImageView.layer.cornerRadius = 10;
    thumbnailImageView.layer.masksToBounds = YES;
    
    [contactListViewController.view addSubview:thumbnailImageView];
    
    
    
    if(CGRectContainsRect([UIScreen mainScreen].bounds, scaledRect)){
        NSLog(@"scaled Rect is inside mainScreen");
        
        [UIView animateWithDuration:1 animations:^{
            thumbnailImageView.transform = t;
        }];
        

    } else {
        NSLog(@"scaled Rect is NOT inside mainScreen");
        int padding = 8;
        
        CGAffineTransform translation;
        
        UIView *pupleView = [UIView new];
        pupleView.backgroundColor = [UIColor purpleColor];
        CGRect pupleViewFrame = CGRectZero;
        pupleViewFrame.size = CGSizeMake(20, scaledRect.size.height);
        pupleViewFrame.origin.y = CGRectGetMinY(scaledRect) + padding;
        pupleView.alpha = 0;
        
        [contactListViewController.view addSubview:pupleView];
        
        if(CGRectGetMinX(scaledRect) < 0.0f){
            float rightShift = padding -(CGRectGetMinX(scaledRect));
            
            translation = CGAffineTransformMakeTranslation(rightShift, padding);
            
            pupleViewFrame.origin.x = CGRectGetMaxX(scaledRect) + 10 + padding;
            
        } else {
            float leftShift = -(CGRectGetMaxX(scaledRect) - CGRectGetWidth([UIScreen mainScreen].bounds) + padding);
            
            translation = CGAffineTransformMakeTranslation(leftShift, padding);
            
            pupleViewFrame.origin.x = (CGRectGetMinX(scaledRect)+leftShift) - 28;
        }
        
        pupleView.frame = pupleViewFrame;
        
        
        
        CGAffineTransform translationWithScaling = CGAffineTransformScale(translation, scalingFactor, scalingFactor);
        [UIView animateWithDuration:.8 animations:^{
            thumbnailImageView.transform = translationWithScaling;
            pupleView.alpha = 1;
        }];
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
