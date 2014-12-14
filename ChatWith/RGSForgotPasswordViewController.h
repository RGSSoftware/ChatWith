//
//  RGSForgotPasswordViewController.h
//  ChatWith
//
//  Created by PC on 12/13/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"

@interface RGSForgotPasswordViewController : RGSBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)reset:(id)sender;

@end
