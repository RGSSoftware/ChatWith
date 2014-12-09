//
//  RGSOverviewAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSOverviewAnimatonController.h"

@implementation RGSOverviewAnimatonController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return .21;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    UIViewController* toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect bottomScreenRect = toVC.view.frame;
    bottomScreenRect.origin = CGPointMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]));
    toVC.view.frame = bottomScreenRect;
    [inView addSubview:toVC.view];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [inView insertSubview:backgroundView belowSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    [UIView animateWithDuration:.21
//                     animations:^{
//                         backgroundView.alpha = .21;
//                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                     }];
    
    [UIView transitionWithView:[transitionContext containerView] duration:0.21 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        backgroundView.alpha = .21;
        [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
//        fromViewController.backgroundView.hidden = NO;
//        toViewController.backgroundView.hidden = NO;
//        
//        [self.backgroundView removeFromSuperview];
//        self.backgroundView = nil;
//        
//        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
}
@end
