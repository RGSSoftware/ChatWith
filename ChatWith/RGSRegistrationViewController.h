//
//  RGSRegistrationViewController.h
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"

@interface RGSRegistrationViewController : RGSBaseViewController
@property (weak, nonatomic) IBOutlet UIView *userImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *addUserImageButtom;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)submit:(id)sender;
@end
