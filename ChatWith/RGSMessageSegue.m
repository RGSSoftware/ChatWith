//
//  RGSMessageSegue.m
//  ChatWith
//
//  Created by PC on 11/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageSegue.h"
#import "RGSContactListViewController.h"
#import "RGSMessageListViewController.h"

#import "UIColor+RGSColorWithHexString.h"

@implementation RGSMessageSegue
-(void)perform{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    UIView *transtionView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [mainWindow addSubview:transtionView];
    [mainWindow bringSubviewToFront:transtionView];
    
    //space backgroundview
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundView.frame = ((UIViewController *)self.sourceViewController).view.frame;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [mainWindow insertSubview:backgroundView atIndex:1];
    
    UIView *navViewImage = [((UIViewController *)self.sourceViewController).navigationController.navigationBar snapshotViewAfterScreenUpdates:NO];
    navViewImage.frame = CGRectMake(0, 20, CGRectGetWidth(navViewImage.frame), CGRectGetHeight(navViewImage.frame));
    
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navViewImage.frame), 20)];
    topBarView.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.85];
    
    UIView *conNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navViewImage.frame), 20 + CGRectGetHeight(navViewImage.frame))];
    [conNavView addSubview:topBarView];
    [conNavView addSubview:navViewImage];
    [transtionView addSubview:conNavView];
    
    

    //setting RGSContactListViewController.backgroundView to hidden
    //to caputure its view picture without the background
    ((RGSContactListViewController *)self.sourceViewController).backgroundView.hidden = YES;
    UIView *sourceView = [((UIViewController *)self.sourceViewController).view snapshotViewAfterScreenUpdates:YES];
    [transtionView addSubview:sourceView];
    
    
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
    
    UIView *destinationNavViewImage = [((UIViewController *)self.destinationViewController).navigationController.navigationBar snapshotViewAfterScreenUpdates:YES];
    destinationNavViewImage.frame = CGRectMake(0, 20, CGRectGetWidth(navViewImage.frame), CGRectGetHeight(navViewImage.frame));
    
    UIView *destinationTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navViewImage.frame), 20)];
    destinationTopBarView.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.85];
    
    UIView *destinationConNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(navViewImage.frame), 20 + CGRectGetHeight(navViewImage.frame))];
    [destinationConNavView addSubview:destinationTopBarView];
    [destinationConNavView addSubview:destinationNavViewImage];
    destinationConNavView.alpha = .25;
    [transtionView addSubview:destinationConNavView];
   
    ((RGSContactListViewController *)self.destinationViewController).backgroundView.hidden = YES;
    UIView *destinationView = [((UIViewController *)self.destinationViewController).view snapshotViewAfterScreenUpdates:YES];
    destinationView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds),
                                       0,
                                       CGRectGetWidth(((UIViewController *)self.destinationViewController).view.frame),
                                       CGRectGetHeight(((UIViewController *)self.destinationViewController).view.frame)
                                       );
    [transtionView addSubview:destinationView];
    
    CGRect middleScreen = ((UIViewController *)self.sourceViewController).view.frame;
    
    CGRect leftOffScreen = CGRectMake(-(CGRectGetWidth([UIScreen mainScreen].bounds)),
                                      0,
                                      CGRectGetWidth([UIScreen mainScreen].bounds),
                                      CGRectGetHeight([UIScreen mainScreen].bounds));
    
    
    [UIView animateWithDuration:0.3f delay:.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        conNavView.alpha = 0;
        destinationConNavView.alpha = 1;
        
        sourceView.frame = leftOffScreen;
        destinationView.frame = middleScreen;
        
    } completion:^(BOOL completed) {
        ((RGSContactListViewController *)self.sourceViewController).backgroundView.hidden = NO;
        ((RGSMessageListViewController *)self.destinationViewController).backgroundView.hidden = NO;
      
        [transtionView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}
@end
