//
//  RGSMessageListViewControllerTwoPop.m
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewControllerTwoPop.h"
#import "RGSMessageComposerView.h"
#import "CSGrowingTextView.h"

@implementation RGSMessageListViewControllerTwoPop


-(void)toChatListScreen:(id)sender{
    if([self.messageComposerView.messageTextView.internalTextView isFirstResponder]){
        [self.messageComposerView.messageTextView.internalTextView resignFirstResponder];
    } else {
        [self performSegueWithIdentifier:@"fromMessageToChat" sender:self];
    }
}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
    [self performSegueWithIdentifier:@"fromMessageToChat" sender:self];
}

@end
