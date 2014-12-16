//
//  RGSCloseSideMenuAnimationController.m
//  ChatWith
//
//  Created by PC on 12/16/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSCloseSideMenuAnimationController.h"

#import "RGSSideMenuViewController.h"

#import "RGSBaseViewController.h"

@interface RGSCloseSideMenuAnimationController ()
@property (nonatomic, strong)UIImageView *backgroundView;
@end

@implementation RGSCloseSideMenuAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    RGSBaseViewController* toVC = (RGSBaseViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.backgroundView.hidden = YES;
    RGSSideMenuViewController* fromVC = (RGSSideMenuViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.backgroundView.hidden = YES;
    
    
    CGRect middleScreenRect = toVC.view.frame;
    middleScreenRect.origin = CGPointZero;
    toVC.view.frame = middleScreenRect;
    toVC.view.hidden = YES;
    [inView addSubview:toVC.view];
    
    [inView addSubview:fromVC.subFromView];
    
    
//    [[transitionContext containerView] addSubview:self.backgroundView];
//    [[transitionContext containerView] sendSubviewToBack:self.backgroundView];
    
    [UIView transitionWithView:[transitionContext containerView]
                      duration:self.transitionDuration
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        
                        CGRect offScreen = fromVC.view.frame;
                        offScreen.origin = CGPointMake(fromVC.buttonsTableView.frame.size.width, 0);
                        fromVC.view.frame = offScreen;
            
                        fromVC.subFromView.frame = [UIScreen mainScreen].bounds;

                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            toVC.view.hidden = NO;
                            [fromVC.subFromView removeFromSuperview];
                            
                            [transitionContext completeTransition:YES];
                        }
//                        [self.backgroundView removeFromSuperview];
//                        self.backgroundView = nil;
                        
                        
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
