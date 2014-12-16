//
//  RGShowSideMenuAnimationController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGShowSideMenuAnimationController.h"

@implementation RGShowSideMenuAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController* toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect rightOffScreenRect = toVC.view.frame;
    rightOffScreenRect.origin = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), 0);
    toVC.view.frame = rightOffScreenRect;
    [inView addSubview:toVC.view];
    
    
    UIView *snapFromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    [inView addSubview:snapFromView];
    
    fromVC.view.hidden = YES;
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
        
        CGRect leftToSide = snapFromView.frame;
        leftToSide.origin = CGPointMake(-150, 76);
        snapFromView.frame = leftToSide;
        
        CGRect middle = toVC.view.frame;
        middle.origin.x = 150;
        toVC.view.frame = middle;
       
    } completion:^(BOOL finished) {
        
                
        [transitionContext completeTransition:YES];
    }];

}


@end
