//
//  RGSCloseSideMenuAnimationController.m
//  ChatWith
//
//  Created by PC on 12/16/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSCloseSideMenuAnimationController.h"

#import "RGSSideMenuViewController.h"
@implementation RGSCloseSideMenuAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSSideMenuViewController* fromViewController = (RGSSideMenuViewController *)self.fromViewController;
        
    CGRect middleScreenRect = self.toViewController.view.frame;
    middleScreenRect.origin = CGPointZero;
    self.toViewController.view.frame = middleScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];
    
    [[transitionContext containerView] addSubview:fromViewController.subFromView];
    [[transitionContext containerView] addSubview:fromViewController.outLineView];
    [[transitionContext containerView] addSubview:fromViewController.tintView];
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        
                        CGRect offScreen = fromViewController.view.frame;
                        offScreen.origin = CGPointMake(fromViewController.buttonsTableView.frame.size.width, 0);
                        fromViewController.view.frame = offScreen;
            
                        fromViewController.subFromView.frame = [UIScreen mainScreen].bounds;
                        
                        fromViewController.outLineView.alpha = 0;
                        fromViewController.outLineView .frame = [UIScreen mainScreen].bounds;
                        fromViewController.tintView.alpha = 0;
                        fromViewController.tintView .frame = [UIScreen mainScreen].bounds;

                    } completion:^(BOOL finished) {
                        if (finished) {
                            self.toViewController.view.hidden = NO;
                            [fromViewController.subFromView removeFromSuperview];
                            [fromViewController.outLineView removeFromSuperview];
                            [fromViewController.tintView removeFromSuperview];
                            
                            [transitionContext completeTransition:YES];
                        }
                    }];
}

@end
