//
//  RGSSplashDismissSegue.m
//  ChatWith
//
//  Created by PC on 1/31/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSSplashDismissSegue.h"
#import "RGSInitialViewController.h"


@implementation RGSSplashDismissSegue

-(void)perform{
    
//    RGSInitialViewController *s = (RGSInitialViewController *)self.sourceViewController;
//    
//    s.logo.alpha = 0;
//    s.view.backgroundColor =  [UIColor yellowColor];
//    s.view.frame = CGRectMake(0, 80, 320, 560);
////    s.view.alpha = 0;
//    
//    UIViewController *vc = self.destinationViewController;
//    vc.view.frame = CGRectMake(0, 0, 320, 560);
//    vc.view.backgroundColor = [UIColor redColor];
//    vc.view.layer.borderWidth = 2;
    
  
    [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
}

@end
