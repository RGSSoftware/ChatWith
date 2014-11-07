//
//  RGSPopSegue.m
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPopSegue.h"

#import "RGSBaseViewController.h"
#import "RGSChatListViewController.h"

#import "UIColor+RGSColorWithHexString.h"

@interface RGSPopSegue()
@property (nonatomic, weak)RGSBaseViewController *popToController;
@end


@implementation RGSPopSegue

-(void)perform{
    
    self.popToController = [[self sourceViewController] navigationController].viewControllers[0];
    
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    //space backgroundview
    static UIImageView *backgroundView = nil;
    if (backgroundView == nil) {
        backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        backgroundView.frame = ((UIViewController *)self.sourceViewController).view.frame;
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    [mainWindow insertSubview:backgroundView atIndex:1];
    
    UIView *transtionView = [[UIView alloc] initWithFrame:((UIViewController *)self.sourceViewController).view.frame];
    [mainWindow addSubview:transtionView];
    
    UIView *sourceNavViewImage = [self createNavImageFromController:(UIViewController *)self.sourceViewController];
    UIView *sourceConNavView = [self createNavViewContainerWithNavImage:sourceNavViewImage];
    [transtionView addSubview:sourceConNavView];
    
    ((RGSBaseViewController *)self.sourceViewController).backgroundView.hidden = YES;
    UIView *sourceView = [((UIViewController *)self.sourceViewController).view snapshotViewAfterScreenUpdates:YES];
    [transtionView addSubview:sourceView];
    
    
    //////////////////////
    [[[self sourceViewController] navigationController] popViewControllerAnimated:NO];
    
    UIView *destinationNavViewImage = [self createNavImageFromController:self.popToController];
    UIView *destinationConNavView = [self createNavViewContainerWithNavImage:destinationNavViewImage];
    destinationConNavView.alpha = .25;
    [transtionView addSubview:destinationConNavView];
//
    self.popToController.backgroundView.hidden = YES;
    
    UIView *popToControllerImageView = [self.popToController.view snapshotViewAfterScreenUpdates:YES];
    popToControllerImageView.frame = [self leftOffSreenRect];
    [transtionView addSubview:popToControllerImageView];

    
    [UIView animateWithDuration:0.3f delay:.0f options:UIViewAnimationOptionCurveLinear animations:^{
//
        sourceConNavView.alpha = 0;
        destinationConNavView.alpha = 1;

        sourceView.frame = [self rightOffSreenRect];
        popToControllerImageView.frame = [self middleSreenRect];
//
    } completion:^(BOOL completed) {
        ((RGSBaseViewController *)self.sourceViewController).backgroundView.hidden = NO;
        ((RGSBaseViewController *)self.popToController).backgroundView.hidden = NO;
////
        [transtionView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}
-(CGRect)leftOffSreenRect{
    return CGRectMake(-(CGRectGetWidth([UIScreen mainScreen].bounds)),
                      0,
                      CGRectGetWidth(self.popToController.view.frame),
                      CGRectGetHeight(self.popToController.view.frame)
                      );
}
-(CGRect)rightOffSreenRect{
    return CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)),
                      0,
                      CGRectGetWidth([UIScreen mainScreen].bounds),
                      CGRectGetHeight([UIScreen mainScreen].bounds));
}
-(CGRect)middleSreenRect{
    return [UIScreen mainScreen].bounds;
}

-(UIView *)createNavViewContainerWithNavImage:(UIView *)navImage{
    UIView *navViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navImage.frame), 20 + CGRectGetHeight(navImage.frame))];
    [navViewContainer addSubview:navImage];
    
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navImage.frame), 20)];
    topBarView.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.85];
    [navViewContainer addSubview:topBarView];
    
    return navViewContainer;
}

-(UIView *)createNavImageFromController:(UIViewController *)controller{
    UIView *navImage = [controller.navigationController.navigationBar snapshotViewAfterScreenUpdates:YES];
    navImage.frame = CGRectMake(0, 20, CGRectGetWidth(navImage.frame), CGRectGetHeight(navImage.frame));
    return navImage;
}

@end
