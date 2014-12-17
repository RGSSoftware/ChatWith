//
//  RGSDismissModallyAnimatonController.m
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSDismissModallyAnimatonController.h"
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
    [self setTopOffScreenRectSize:self.toViewController.view.frame.size];
    self.toViewController.view.frame = self.topOffScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];

    [self setBottomOffScreenRectSize:self.fromViewController.view.frame.size];
    
    [self setCenterScreenRectSize:self.toViewController.view.frame.size];
    
    UIView *tintView = [self tintViewWithFrame:self.topOffScreenRect];
    tintView.alpha = .7;
    [[transitionContext containerView] addSubview:tintView];
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        self.toViewController.view.frame = self.centerScreenRect;
        self.fromViewController.view.frame = self.bottomOffScreenRect;
        
        tintView.alpha = 0;
        tintView.frame = self.centerScreenRect;
    } completion:^(BOOL finished) {
        if(finished){
            [self.fromViewController.view removeFromSuperview];
            [tintView removeFromSuperview];
            
            [transitionContext completeTransition:YES];
        }
    }];
    
}


@end