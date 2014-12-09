//
//  RGSOverviewAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSOverviewAnimatonController.h"

@interface RGSOverviewAnimatonController()
@property float transitionDuration;
@end

@implementation RGSOverviewAnimatonController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .21;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
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
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
        backgroundView.alpha = .21;
        [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    }
                    completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
