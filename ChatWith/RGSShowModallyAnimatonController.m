//
//  RGSShowModallyAnimatonController.m
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSShowModallyAnimatonController.h"
#import "RGSBaseViewController.h"



@implementation RGSShowModallyAnimatonController

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
    
    CGRect bottomOffScreenRect = toViewController.view.frame;
    bottomOffScreenRect.origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height);
    toViewController.view.frame = bottomOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect topOffScreenRect = fromViewController.view.frame;
    topOffScreenRect.origin = CGPointMake(0, -[UIScreen mainScreen].bounds.size.height);
    
    CGRect centerScreenRect = toViewController.view.frame;
    centerScreenRect.origin = CGPointZero;
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
        
        toViewController.view.frame = centerScreenRect;
        fromViewController.view.frame = topOffScreenRect;
    } completion:^(BOOL finished) {
        
        [fromViewController.view removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    
}



@end
