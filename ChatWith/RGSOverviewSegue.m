//
//  RGSOverviewSegue.m
//  ChatWith
//
//  Created by PC on 11/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSOverviewSegue.h"
#import "RGSMessageListViewController.h"
#import "RGSMessageComposerView.h"

@interface RGSOverviewSegue () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property BOOL isPresenting;
@end

@implementation RGSOverviewSegue
-(void)perform{
    
        [((UIViewController *)self.destinationViewController) setTransitioningDelegate:((UIViewController *)self.sourceViewController).navigationController];
        ((UIViewController *)self.destinationViewController).modalPresentationStyle = UIModalPresentationCustom;
            
    [((UIViewController *)self.sourceViewController) presentViewController:self.destinationViewController animated:YES completion:nil];
}

//===================================================================
// - UIViewControllerAnimatedTransitioning
//===================================================================

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return .21;
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
    [UIView animateWithDuration:.21
                     animations:^{
                         backgroundView.alpha = .21;
                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}


//===================================================================
// - UIViewControllerTransitioningDelegate
//===================================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}
@end
