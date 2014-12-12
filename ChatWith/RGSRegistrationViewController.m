//
//  RGSRegistrationViewController.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSRegistrationViewController.h"
#import "RGSUserMangementService.h"
#import "RGSChatService.h"
#import "LocalStorageService.h"
#import "ApplicationSession.h"

#import "NSString+alphaOnly.h"

#import "RGSMessageAttachmentViewController.h"

#import "UIColor+RGSColorWithHexString.h"

#import "NSAttributedString+RGSExtras.h"
#import "NSMutableAttributedString+RGSExtras.h"
#import "NSString+RGSAttributedString.h"

#import <Quickblox/QBRequest+QBAuth.h>



@interface RGSRegistrationViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;
@property (nonatomic, strong)NSMutableArray *buttons;
@end

@implementation RGSRegistrationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self baseInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit{
    
    _textFields = [NSMutableArray array];
    _buttons = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.textFields addObjectsFromArray:@[self.usernameTextField,
                                           self.passwordTextField,
                                           self.emailTextField,
                                           self.firstnameTextField,
                                           self.lastnameTextField,
                                           self.phonenumberTextField]];
    
    for (UITextField *textField in self.textFields) {
        textField.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
        textField.layer.borderColor = [[UIColor clearColor] CGColor];
        textField.textColor = [UIColor whiteColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 10;
        
        NSMutableAttributedString *attributedString = [[textField.placeholder attributedString] mutableCopy];
        [attributedString setColor:[UIColor colorWithWhite:0.830 alpha:1.000]];
        textField.attributedPlaceholder = attributedString;
    }
    
    [self.buttons addObjectsFromArray:@[self.addUserImageButtom, self.submitButton]];
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
        [button.layer setCornerRadius:10];
        [button setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    
    [self.userImage.layer setCornerRadius:10];
    self.userImage.clipsToBounds = YES;
    
    
}
- (void)viewDidLayoutSubviews {
self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.submitButton.frame) + 5);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(65, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0, -65);

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[RGSMessageAttachmentViewController class]]) {
        RGSMessageAttachmentViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
    }
}

#pragma mark - RGSMessageAttachmentViewControllerDelegate ()
-(void)RGSMessageAttachmentViewController:(RGSMessageAttachmentViewController *)messageAttachmentViewController imageAttachment:(UIImage *)imageAttachment{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.userImage.image = imageAttachment;
}

- (IBAction)submit:(id)sender {
    
    if ([self isUserCredentialsValid]) {
        [[RGSUserMangementService shared]
         isUsernameTaken:self.usernameTextField.text
         successBlock:^(BOOL isTaken) {
         if(!isTaken){
             
             
             QBUUser *user = [QBUUser user];
             user.login = self.usernameTextField.text;
             user.password = self.passwordTextField.text;
             [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
                 if(response.success && !response.error){
                     //login user
                     [QBRequest logInWithUserLogin:user.login password:user.password successBlock:^(QBResponse *response, QBUUser *user) {
                         if(response.success){
                             [[LocalStorageService shared] creteCurrentUserWithQBUser:user successBlock:^(BOOL success, NSError *error) {
                                 //loign to chat
                                 [[RGSChatService shared] loginUser:user successBlock:^(BOOL success) {
                                     
                                     //on success, instantiate initial ViewController from storyboard
                                     if(success){
                                         [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController] animated:YES completion:nil];
                                     }
                                 }];
                             }];
                         }
                     } errorBlock:^(QBResponse *response) {
                         
                     }];
                 }
             } errorBlock:^(QBResponse *response) {
                 {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
             }];
             
         } else {[self showAlertViewWithMeassage:@"Oops! Somebody already has that name. Give it another shot."];}
                                             }];
    } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
}

- (BOOL)isPasswordValid:(NSString *)password
{
    if (password && !(password.length <= 4) && (password.length <=15)) {
        return YES;
    }
    
    return NO;
}
- (BOOL)isUserNameValid:(NSString *)username
{
    if(username && !(username.length == 0) && (username.length <= 20)){
        
        return [username isAlphaNumeric];
    }
    return NO;
}


-(BOOL)isUserCredentialsValid{
    return ([self isUserNameValid:self.usernameTextField.text] &&
            [self isPasswordValid:self.passwordTextField.text]);
}

- (void)showAlertViewWithMeassage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
}

@end
