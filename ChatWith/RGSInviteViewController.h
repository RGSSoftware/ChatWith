//
//  RGSInviteViewController.h
//  ChatWith
//
//  Created by PC on 12/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSInviteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendSmsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelInviteButton;

- (IBAction)sendSms:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)cancelInvite:(id)sender;

@end
