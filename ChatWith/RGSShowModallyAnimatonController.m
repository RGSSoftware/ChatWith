//
//  RGSShowModallyAnimatonController.m
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSShowModallyAnimatonController.h"

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
    [self setBottomOffScreenRectSize:self.toViewController.view.frame.size];
    self.toViewController.view.frame = self.bottomOffScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];
    
    [self setTopOffScreenRectSize:self.fromViewController.view.frame.size];
    
    [self setCenterScreenRectSize:self.toViewController.view.frame.size];
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
        
        self.toViewController.view.frame = self.centerScreenRect;
        self.fromViewController.view.frame = self.topOffScreenRect;
    } completion:^(BOOL finished) {
        if(finished){
            [self.fromViewController.view removeFromSuperview];
            
            [transitionContext completeTransition:YES];
        }
    }];
    
}



@end
