//
//  RGSMessageSegue.m
//  ChatWith
//
//  Created by PC on 11/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageSegue.h"

#import "RGSBaseViewController.h"

@interface RGSMessageSegue()
@property (nonatomic, strong)UIImageView *backgroundView;
@end

@implementation RGSMessageSegue
-(void)perform{
    [((UIViewController *)self.sourceViewController).navigationController setDelegate:self];
    [((UIViewController *)self.sourceViewController).navigationController pushViewController:self.destinationViewController animated:YES];
}
#pragma mark - UIViewControllerAnimatedTransitioning ()
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    RGSBaseViewController *fromViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.backgroundView.hidden = YES;
    
    RGSBaseViewController *toViewController = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.backgroundView.hidden = YES;
    
    CGRect rightOffScreenRect = toViewController.view.frame;
    rightOffScreenRect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    toViewController.view.frame = rightOffScreenRect;
    [[transitionContext containerView] addSubview:toViewController.view];
    
    [[transitionContext containerView] addSubview:self.backgroundView];
    [[transitionContext containerView] sendSubviewToBack:self.backgroundView];
    
    CGRect leftOffScreenRect = fromViewController.view.frame;
    leftOffScreenRect.origin = CGPointMake(-[UIScreen mainScreen].bounds.size.width, 0);
    
    CGRect centerScreenRect = toViewController.view.frame;
    centerScreenRect.origin = CGPointZero;
    
    [UIView transitionWithView:[transitionContext containerView] duration:0.35 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        toViewController.view.frame = centerScreenRect;
        fromViewController.view.frame = leftOffScreenRect;
    } completion:^(BOOL finished) {

        fromViewController.backgroundView.hidden = NO;
        toViewController.backgroundView.hidden = NO;
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;

        [fromViewController.view removeFromSuperview];

        [transitionContext completeTransition:YES];
    }];
    
}
#pragma mark - UINavigationControllerDelegate ()
-(id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return self;
}

#pragma mark - Heplers ()
-(UIImageView *)backgroundView{
    if(_backgroundView == nil){
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        _backgroundView.frame = [UIScreen mainScreen].bounds;
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}
@end
