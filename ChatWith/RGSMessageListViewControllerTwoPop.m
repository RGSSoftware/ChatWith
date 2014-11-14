//
//  RGSMessageListViewControllerTwoPop.m
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewControllerTwoPop.h"

@implementation RGSMessageListViewControllerTwoPop


-(void)toChatListScreen:(id)sender{
    [self performSegueWithIdentifier:@"fromMessageToChat" sender:self];
}

@end
