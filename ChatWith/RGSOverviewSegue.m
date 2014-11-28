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
    
        [((UIViewController *)self.destinationViewController) setTransitioningDelegate:self];
        ((UIViewController *)self.destinationViewController).modalPresentationStyle = UIModalPresentationCustom;
        
         [((RGSMessageListViewController *)self.sourceViewController).messageComposerView.messageTextView resignFirstResponder];
    
    [((UIViewController *)self.sourceViewController) presentViewController:self.destinationViewController animated:YES completion:nil];
}

//===================================================================
// - UIViewControllerAnimatedTransitioning
//===================================================================

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    UIViewController* toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0
                     animations:^{
                         
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
