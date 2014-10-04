//
//  RGSLoginViewController.h
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RGSUserMangementService;


@interface RGSLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView      *loginView;
@property (nonatomic, strong) IBOutlet UIView      *registrationView;

@property (nonatomic, weak  ) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak  ) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong)Class alertViewClass;


@property (nonatomic, strong)RGSUserMangementService  *userManger;

-(IBAction)loginUser:(id)sender;
-(IBAction)registerUser:(id)sender;

@end

