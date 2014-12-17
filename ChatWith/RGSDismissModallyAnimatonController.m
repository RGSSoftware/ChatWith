//
//  RGSDismissModallyAnimatonController.m
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSDismissModallyAnimatonController.h"

#import "RGSBaseViewController.h"

@interface RGSDismissModallyAnimatonController ()

@end


@implementation RGSDismissModallyAnimatonController

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
    
    CGRect topOffScreenRect = toViewController.view.frame;
    topOffScreenRect.origin = CGPointMake(0, -[UIScreen mainScreen].bounds.size.height);
    toViewController.view.frame = topOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
    
    
    CGRect bottomOffScreenRect = fromViewController.view.frame;
    bottomOffScreenRect.origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height);
    
    CGRect centerScreenRect = toViewController.view.frame;
    centerScreenRect.origin = CGPointZero;
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        toViewController.view.frame = centerScreenRect;
        fromViewController.view.frame = bottomOffScreenRect;
    } completion:^(BOOL finished) {
        
        
        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    
}


@end