//
//  RGSOverviewAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSShowOverviewAnimatonController.h"

#import "RGSBaseOverviewViewController.h"

@implementation RGSShowOverviewAnimatonController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .21;
    }
    return self;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseOverviewViewController *overviewViewController = (RGSBaseOverviewViewController *)self.toViewController;
    
    CGRect bottomScreenRect = overviewViewController.view.frame;
    bottomScreenRect.origin = CGPointMake(0, 200);
    overviewViewController.view.frame = bottomScreenRect;
    [[transitionContext containerView] addSubview:self.toViewController.view];
    
    [[transitionContext containerView] insertSubview:overviewViewController.tintView belowSubview:overviewViewController.view];
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveEaseIn| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
        overviewViewController.tintView.alpha = .21;
        [overviewViewController.view setFrame:CGRectMake(0, 0, self.fromViewController.view.frame.size.width, self.fromViewController.view.frame.size.height)];
    }
                    completion:^(BOOL finished) {
                        if(finished){
                            [overviewViewController.view addSubview:overviewViewController.tintView];
                            [overviewViewController.view sendSubviewToBack:overviewViewController.tintView];
                            
                            [transitionContext completeTransition:YES];

                        }
    }];
}
@end
