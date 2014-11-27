//
//  RGSMessageSegue.m
//  ChatWith
//
//  Created by PC on 11/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageSegue.h"

#import "RGSBaseViewController.h"

#import "UIColor+RGSColorWithHexString.h"
@interface RGSMessageSegue()
@property (nonatomic, strong)UIImageView *backgroundView;
@end

@implementation RGSMessageSegue
-(void)perform{
    [((UIViewController *)self.sourceViewController).navigationController setDelegate:self];
    [((UIViewController *)self.sourceViewController).navigationController pushViewController:self.destinationViewController animated:YES];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseViewController *fromViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.backgroundView.hidden = YES;
    
    RGSBaseViewController *toViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.backgroundView.hidden = YES;
    
    toViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, CGRectGetWidth(toViewController.view.frame), CGRectGetHeight(toViewController.view.frame));
    [[transitionContext containerView] addSubview:toViewController.view];
    
    [[transitionContext containerView] addSubview:self.backgroundView];
    [[transitionContext containerView] sendSubviewToBack:self.backgroundView];
    
    CGRect finalFrame = toViewController.view.frame;
    finalFrame.origin = CGPointZero;
    
    CGRect finalFrameforFrom = toViewController.view.frame;
    finalFrameforFrom.origin = CGPointMake(-[UIScreen mainScreen].bounds.size.width, 0);
    [UIView transitionWithView:[transitionContext containerView] duration:0.35 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        toViewController.view.frame = finalFrame;
        fromViewController.view.frame= finalFrameforFrom;
        //        [toViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        //                        }
        fromViewController.backgroundView.hidden = NO;
        toViewController.backgroundView.hidden = NO;
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;

        [transitionContext completeTransition:YES];
    }];
    
}
-(id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return self;
}

-(UIImageView *)backgroundView{
    if(_backgroundView == nil){
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        _backgroundView.frame = [UIScreen mainScreen].bounds;
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}
@end
