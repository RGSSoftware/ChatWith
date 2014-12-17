//
//  RGSBaseAnimatonController.h
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGSBaseAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property float transitionDuration;

@property(nonatomic, readonly)UIViewController *fromViewController;
@property(nonatomic, readonly)UIViewController *toViewController;

@property CGRect centerScreenRect;
-(void)setCenterScreenRectSize:(CGSize)size;

@property CGRect leftOffScreenRect;
-(void)setLeftOffScreenRectSize:(CGSize)size;

@property CGRect rightOffScreenRect;
-(void)setRightOffScreenRectSize:(CGSize)size;

@end
