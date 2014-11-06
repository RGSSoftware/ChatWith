//
//  RGSCustomNavigationController.m
//  ChatWith
//
//  Created by PC on 11/4/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSCustomNavigationController.h"
#import "RGSMessageListViewController.h"

@implementation RGSCustomNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if([[self.viewControllers lastObject] class] == [RGSMessageListViewController class]){
        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration: 1.00];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
//                               forView:self.view cache:NO];
        
//        [super popViewControllerAnimated:NO];
        NSArray *viewControllers = [super popToViewController:[self.viewControllers objectAtIndex:([self.viewControllers count]- 2)] animated:NO];
        
//        [UIView commitAnimations];
        
        return [viewControllers lastObject];
    } else {
        return [super popViewControllerAnimated:animated];
    }
}
@end


