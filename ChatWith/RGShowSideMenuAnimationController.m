//
//  RGShowSideMenuAnimationController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGShowSideMenuAnimationController.h"

#import "RGSSideMenuViewController.h"

#import "RGSBaseViewController.h"

@interface RGShowSideMenuAnimationController ()
@property (nonatomic, strong)UIImageView *backgroundView;
@end

@implementation RGShowSideMenuAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    RGSSideMenuViewController* toVC = (RGSSideMenuViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.backgroundView.hidden = YES;
    RGSBaseViewController* fromVC = (RGSBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.backgroundView.hidden = YES;
//    fromVC.view.backgroundColor = [UIColor redColor];
    
    CGRect rightOffScreenRect = toVC.view.frame;
    rightOffScreenRect.origin = CGPointMake(toVC.buttonsTableView.frame.size.width, 0);
    toVC.view.frame = rightOffScreenRect;
    [inView addSubview:toVC.view];
    
    
    UIView *snapFromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    snapFromView.backgroundColor = [UIColor redColor];
    [inView addSubview:snapFromView];
    
    CGRect offScreen = fromVC.view.frame;
    offScreen.origin.x = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    fromVC.view.frame = offScreen;
    
//    toVC.fromView.backgroundColor = [UIColor purpleColor];
    [[transitionContext containerView] addSubview:self.backgroundView];
    [[transitionContext containerView] sendSubviewToBack:self.backgroundView];
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
        
                        CGRect leftToSide = toVC.fromView.frame;
        
                        leftToSide.size.height = 380;
                        snapFromView.frame = leftToSide;
        
                        CGRect middle = toVC.view.frame;
                        middle.origin.x = 0;
                        toVC.view.frame = middle;
       
    } completion:^(BOOL finished) {
        
        if(finished){
//            CGRect testRect = snapFromView.frame;
////            testRect.origin = CGPointMake(8, 0);
//            snapFromView.frame = testRect;
            toVC.subFromView = snapFromView;
            [toVC.view addSubview:snapFromView];
//            toVC.fromView = snapFromView;
//            [toVC.fromView addSubview:snapFromView];
            
            
            [toVC.view bringSubviewToFront:toVC.closeTapView];
            
            
            [self.backgroundView removeFromSuperview];
            self.backgroundView = nil;
//            [snapFromView removeFromSuperview];
//            toVC.backgroundView.hidden = NO;
            
            [transitionContext completeTransition:YES];
        }
        
    }];

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
