//
//  RGSPushAnimationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPushAnimationController.h"
#import "RGSBaseViewController.h"

#import "dashBorderView.h"


@implementation RGSPushAnimationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .35;
    }
    return self;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self setRightOffScreenRectSize:self.fromViewController.view.frame.size];
    self.toViewController.view.frame = self.rightOffScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];
 
    [self setLeftOffScreenRectSize:self.fromViewController.view.frame.size];
    
    [self setCenterScreenRectSize:self.toViewController.view.frame.size];
    
    UIView *tintView = [self tintViewWithFrame:self.centerScreenRect];
    [[transitionContext containerView] addSubview:tintView];
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        self.toViewController.view.frame = self.centerScreenRect;
        self.fromViewController.view.frame = self.leftOffScreenRect;
        
        tintView.alpha = 1;
        tintView.frame = self.leftOffScreenRect;
        
    } completion:^(BOOL finished) {
        if(finished){
            [self.fromViewController.view removeFromSuperview];
            [tintView removeFromSuperview];
            
            [transitionContext completeTransition:YES];
        }
    }];
}
@end
