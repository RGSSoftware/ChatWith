//
//  RGSPopAnimationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPopAnimationController.h"
#import "RGSBaseViewController.h"

@implementation RGSPopAnimationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .25;
    }
    return self;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseViewController *fromViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    RGSBaseViewController *toViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect rightOffScreenRect = fromViewController.view.frame;
    rightOffScreenRect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    
    
    
    CGRect leftOffScreenRect = toViewController.view.frame;
    leftOffScreenRect.origin = CGPointMake(-[UIScreen mainScreen].bounds.size.width, 0);
    toViewController.view.frame = leftOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
    

    
    CGRect centerScreenRect = toViewController.view.frame;
    centerScreenRect.origin = CGPointZero;
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        toViewController.view.frame = centerScreenRect;
        fromViewController.view.frame = rightOffScreenRect;
    } completion:^(BOOL finished) {
        
        
        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    
}

@end
