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

@property (nonatomic, strong) IBOutlet UIView      *loginView;
@property (nonatomic, strong) IBOutlet UIView      *registrationView;

@property (nonatomic, weak  ) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak  ) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, strong)Class alertViewClass;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;


@property (nonatomic, strong)RGSUserMangementService  *userManger;

-(IBAction)loginUser:(id)sender;
-(IBAction)registerUser:(id)sender;

@end

