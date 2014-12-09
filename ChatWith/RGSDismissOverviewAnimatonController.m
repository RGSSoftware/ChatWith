//
//  RGSDismissOverviewAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSDismissOverviewAnimatonController.h"

@implementation RGSDismissOverviewAnimatonController
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return .21;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    UIViewController* toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:fromVC.view];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = .21;
    [inView insertSubview:backgroundView belowSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [UIView transitionWithView:[transitionContext containerView] duration:0.21 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        backgroundView.alpha = 0;
        [fromVC.view setFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]), fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];

        [transitionContext completeTransition:YES];
    }];
}

@end
