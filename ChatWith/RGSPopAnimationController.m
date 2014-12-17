//
//  RGSPopAnimationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPopAnimationController.h"
#import "RGSBaseViewController.h"

@implementation RGSPopAnimationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .25;
    }
    return self;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    [self setLeftOffScreenRectSize:self.toViewController.view.frame.size];
    self.toViewController.view.frame = self.leftOffScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];
    
   [self setRightOffScreenRectSize:self.fromViewController.view.frame.size];
    
    [self setCenterScreenRectSize:self.toViewController.view.frame.size];
    
    [UIView transitionWithView:[transitionContext containerView] duration:self.transitionDuration options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        self.toViewController.view.frame = self.centerScreenRect;
        self.fromViewController.view.frame = self.rightOffScreenRect;
    } completion:^(BOOL finished) {
        if(finished){
            [self.fromViewController.view removeFromSuperview];
            
            [transitionContext completeTransition:YES];
        }
    }];
    
}

@end
