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
    RGSContact *contact = [contactListViewController contactAtIndex:contactIndex];
    
    NSLog(@"contactCell.thumbnailImageView.frame:%@", NSStringFromCGRect([contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view]));
    
    NSLog(@"screen rect:%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    UIView *snapThumbnailImage = [contactCell.thumbnailImageView snapshotViewAfterScreenUpdates:NO];
//    snapThumbnailImage.backgroundColor = [UIColor redColor];
//    snapThumbnailImage.clipsToBounds = YES;
    
    
    
    snapThumbnailImage.frame = [contactCell.contentView convertRect:contactCell.thumbnailImageView.frame toView:contactListViewController.view];
    [contactListViewController.view addSubview:snapThumbnailImage];
    
//    UIView *yellowView = [UIView new];
//    yellowView.backgroundColor = [UIColor yellowColor];
//    CGRect yellowViewFrame = CGRectZero;
//    yellowViewFrame.origin.x = CGRectGetWidth(snapThumbnailImage.frame)/2;
//    yellowViewFrame.size = snapThumbnailImage.frame.size;
//    yellowView.frame = yellowViewFrame;
//    [snapThumbnailImage addSubview:yellowView];
    
    float scalingFactor = 1.6;
    
    CGAffineTransform t = CGAffineTransformMakeScale(scalingFactor, scalingFactor);
    
    float x = CGRectGetMinX(snapThumbnailImage.frame);
    float y = CGRectGetMinY(snapThumbnailImage.frame);
    float centerX = snapThumbnailImage.center.x;
    float centerY = snapThumbnailImage.center.y;
    
    float scaledX = ((x + -centerX) * scalingFactor) + centerX;
    float scaledY = ((y + -centerY) * scalingFactor) + centerY;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.origin.x = scaledX;
    scaledRect.origin.y = scaledY;
    scaledRect.size = CGSizeApplyAffineTransform(snapThumbnailImage.frame.size, t);;
    

    
    
    if(CGRectContainsRect([UIScreen mainScreen].bounds, scaledRect)){
        NSLog(@"scaled Rect is inside mainScreen");
        
        [UIView animateWithDuration:1.0 animations:^{
            snapThumbnailImage.transform = t;
            
        } completion:^(BOOL finished) {
            if(finished){
                NSLog(@"snapThumbnailImage.frame:%@", NSStringFromCGRect(snapThumbnailImage.frame));
                CGRect snapThumbnailImageFrame = snapThumbnailImage.frame;
                UIImageView *largerThumbnailView = [[UIImageView alloc] initWithFrame:snapThumbnailImageFrame];
                largerThumbnailView.layer.cornerRadius = 10;
                largerThumbnailView.layer.masksToBounds = YES;
                
                UIImage *largerThumbnail;
                switch ([contact.friend.blobID integerValue]) {
                    case 0:
                        largerThumbnail = [UIImage imageNamed:@"sarah_connor"];
                        break;
                    case 1:
                        largerThumbnail = [UIImage imageNamed:@"t1000"];
                        break;
                    case 2:
                        largerThumbnail = [UIImage imageNamed:@"joe_morton"];
                        break;
                    case 3:
                        largerThumbnail = [UIImage imageNamed:@"john_connor"];
                        break;
                    default:
                        break;
                }
                largerThumbnailView.image = largerThumbnail;
                [contactListViewController.view addSubview:largerThumbnailView];
            }
        }];
    } else {
        NSLog(@"scaled Rect is NOT inside mainScreen");
        int padding = 8;
        
        CGAffineTransform translation;
        
        UIView *pupleView = [UIView new];
        pupleView.backgroundColor = [UIColor purpleColor];
        CGRect pupleViewFrame = CGRectZero;
        pupleViewFrame.size = CGSizeMake(20, scaledRect.size.height );
        pupleViewFrame.origin.y = scaledY + padding;
        pupleView.alpha = 0;
        
        [contactListViewController.view addSubview:pupleView];
        
        if(scaledX < 0.0f){
            float rightShift = padding -(scaledX);
            
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
            snapThumbnailImage.transform = translationWithScaling;
            pupleView.alpha = 1;
        }];
    }
    
    NSLog(@"Screen.bounds:%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"scaledRect.frame:%@", NSStringFromCGRect(scaledRect));
//    UIView *snap = [UIView new];
//    snap.backgroundColor = [UIColor yellowColor];
//    
//    snap.frame = CGRectApplyAffineTransform(snapThumbnailImage.frame, t);
//    [contactListViewController.view addSubview:snap];
    
//    snapThumbnailImage.transform = CGAffineTransformScale(snapThumbnailImage.transform, 0.35, 0.35);
    
    
    
}


@end
