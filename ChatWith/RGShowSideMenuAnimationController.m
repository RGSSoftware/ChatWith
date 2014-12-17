//
//  RGShowSideMenuAnimationController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGShowSideMenuAnimationController.h"

#import "RGSSideMenuViewController.h"

#import "RGSBaseViewController.h"

@implementation RGShowSideMenuAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    RGSSideMenuViewController* toVC = (RGSSideMenuViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    RGSBaseViewController* fromVC = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect rightOffScreenRect = toVC.view.frame;
    rightOffScreenRect.origin = CGPointMake(toVC.buttonsTableView.frame.size.width, 0);
    toVC.view.frame = rightOffScreenRect;
    [inView addSubview:toVC.view];
    
    
    UIView *snapFromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    [inView addSubview:snapFromView];
    
    CGRect offScreen = fromVC.view.frame;
    offScreen.origin.x = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    fromVC.view.frame = offScreen;
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
        
                        CGRect leftToSide = toVC.fromView.frame;
        
                        leftToSide.size.height = 380;
                        snapFromView.frame = leftToSide;
        
                        CGRect middle = toVC.view.frame;
                        middle.origin.x = 0;
                        toVC.view.frame = middle;
       
    } completion:^(BOOL finished) {
        
        if(finished){

            toVC.subFromView = snapFromView;
            [toVC.view addSubview:snapFromView];

            
            [toVC.view bringSubviewToFront:toVC.closeTapView];
    

            [transitionContext completeTransition:YES];
        }
        
    }];

}
@end
