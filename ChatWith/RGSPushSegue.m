//
//  RGSMessageSegue.m
//  ChatWith
//
//  Created by PC on 11/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPushSegue.h"

#import "RGSBaseViewController.h"

@interface RGSPushSegue()

@end

@implementation RGSPushSegue
-(void)perform{
//    [((UIViewController *)self.sourceViewController).navigationController setDelegate:self];
    
    [((UIViewController *)self.sourceViewController).navigationController pushViewController:self.destinationViewController animated:YES];
}

#pragma mark - UINavigationControllerDelegate ()
-(id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return self;
}

#pragma mark - Heplers ()

@end
