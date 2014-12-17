//
//  RGSDismissOverviewAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSDismissOverviewAnimatonController.h"
#import "RGSBaseOverviewViewController.h"

@implementation RGSDismissOverviewAnimatonController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .18;
    }
    return self;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseOverviewViewController *overviewViewController = (RGSBaseOverviewViewController *)self.fromViewController;
    
    [[transitionContext containerView] addSubview:overviewViewController.view];
    
    [[transitionContext containerView] insertSubview:overviewViewController.tintView belowSubview:self.toViewController.view];
    
    overviewViewController.tintView.alpha = .21;
        
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        
        overviewViewController.tintView.alpha = 0;
                        
        [overviewViewController.view setFrame:CGRectMake(0,
                                                         200,
                                                         overviewViewController.view.frame.size.width,
                                                         overviewViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
        if(finished){
            
            [overviewViewController.tintView removeFromSuperview];

            [overviewViewController.view removeFromSuperview];
            
            [transitionContext completeTransition:YES];
   
        }
    }];
}

@end
