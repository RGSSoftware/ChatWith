//
//  RGSMessageListViewController.m
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewControllerOnePop.h"

@implementation RGSMessageListViewControllerOnePop

-(void)toChatListScreen:(id)sender{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]- 3)] animated:NO];
    
    [self performSegueWithIdentifier:@"unwindToChatLis" sender:self];
  

    
}

@end
