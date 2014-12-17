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
    RGSSideMenuViewController* toViewController = (RGSSideMenuViewController*)self.toViewController;
    
    CGRect rightOffScreenRect = toViewController.view.frame;
    rightOffScreenRect.origin = CGPointMake(toViewController.buttonsTableView.frame.size.width, 0);
    toViewController.view.frame = rightOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
    
    
    UIView *snapFromView = [self.fromViewController.view snapshotViewAfterScreenUpdates:NO];
    [[transitionContext containerView] addSubview:snapFromView];
    
    self.fromViewController.view.hidden = YES;
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
        
                        CGRect leftToSide = toViewController.fromView.frame;
        
                        leftToSide.size.height = 380;
                        snapFromView.frame = leftToSide;
        
                        CGRect middle = toViewController.view.frame;
                        middle.origin.x = 0;
                        toViewController.view.frame = middle;
       
    } completion:^(BOOL finished) {
        
        if(finished){

            toViewController.subFromView = snapFromView;
            [toViewController.view addSubview:snapFromView];

            
            [toViewController.view bringSubviewToFront:toViewController.closeTapView];
    

            [transitionContext completeTransition:YES];
        }
        
    }];

}
@end
