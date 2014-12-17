//
//  RGSPushAnimationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPushAnimationController.h"
#import "RGSBaseViewController.h"


@implementation RGSPushAnimationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .35;
    }
    return self;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseViewController *fromViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    RGSBaseViewController *toViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect rightOffScreenRect = toViewController.view.frame;
    rightOffScreenRect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    toViewController.view.frame = rightOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
 
    CGRect leftOffScreenRect = fromViewController.view.frame;
    leftOffScreenRect.origin = CGPointMake(-[UIScreen mainScreen].bounds.size.width, 0);
    
    CGRect centerScreenRect = toViewController.view.frame;
    centerScreenRect.origin = CGPointZero;
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        toViewController.view.frame = centerScreenRect;
        fromViewController.view.frame = leftOffScreenRect;
    } completion:^(BOOL finished) {
       
        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    
}
@end
