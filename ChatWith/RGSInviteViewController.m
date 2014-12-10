//
//  RGSInviteViewController.m
//  ChatWith
//
//  Created by PC on 12/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSInviteViewController.h"
#import "IBActionSheet.h"

#import <MessageUI/MessageUI.h>

@interface RGSInviteViewController () <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>


@property IBActionSheet *standardIBAS;
@end

@implementation RGSInviteViewController

-(void)viewWillAppear:(BOOL)animated{
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecongnizer:)];
    [self.view addGestureRecognizer:tapGestureRecongnizer];
}

-(void)tapRecongnizer:(UIGestureRecognizer *)sender{
    
    CGPoint userTouchCoordinate = [sender locationInView:nil];
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if(CGRectContainsPoint(self.cancelInviteButton.frame, userTouchCoordinate))return;
        if(!CGRectContainsPoint(self.sendSmsButton.frame, userTouchCoordinate) ||
           !CGRectContainsPoint(self.sendEmailButton.frame, userTouchCoordinate)){
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


-(IBAction)sendSms:(id)sender{
    MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        
        smsController.messageComposeDelegate = self;
        smsController.body = @"check out apps, link";
        [self presentViewController:smsController animated:YES completion:nil];
    }
    
}
-(IBAction)sendEmail:(id)sender{
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
    mcvc.mailComposeDelegate = self;
    [mcvc setSubject:@"Check out this app"];
    UIImage *image = [UIImage imageNamed:@"Icon"];
    //include your app icon here
    [mcvc addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpg" fileName:@"icon.jpg"];
    // your message and link
    NSString *defaultBody = @"check out this cool apps, link....";
    [mcvc setMessageBody:defaultBody isHTML:YES];
    [self presentViewController:mcvc animated:YES completion:nil];
    
}
-(IBAction)cancelInvite:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
