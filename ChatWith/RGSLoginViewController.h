//
//  RGSLoginViewController.h
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSBaseViewController.h"

@class RGSUserMangementService;


@interface RGSLoginViewController : RGSBaseViewController

@property (nonatomic, weak  ) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak  ) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *rememberMeLabel;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

@property (weak, nonatomic) IBOutlet UIView *container;

-(IBAction)loginUser:(id)sender;
- (IBAction)rememberMe:(id)sender;
@end

