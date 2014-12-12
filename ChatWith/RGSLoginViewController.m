//
//  RGSLoginViewController.m
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSLoginViewController.h"
#import "NSString+alphaOnly.h"
#import "RGSUserMangementService.h"
#import "RGSChatService.h"
#import "LocalStorageService.h"
#import "ApplicationSession.h"

#import "UIColor+RGSColorWithHexString.h"
#import "NSAttributedString+RGSExtras.h"
#import "NSMutableAttributedString+RGSExtras.h"


@interface RGSLoginViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;


@end

@implementation RGSLoginViewController



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
     _userManger = [RGSUserMangementService new];
    
    _textFields = [NSMutableArray arrayWithCapacity:2];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *redSquare = [UILabel new];
    redSquare.frame = CGRectMake(20, 20, 100, 100);
    redSquare.backgroundColor = [UIColor redColor];
    
    
    [self.textFields addObjectsFromArray:@[self.usernameTextField, self.passwordTextField]];
    
    for (UITextField *textField in self.textFields) {
        textField.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
        textField.layer.borderColor = [[UIColor clearColor] CGColor];
        textField.textColor = [UIColor whiteColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 10;
    }
    
    
    
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
    [self.loginButton.layer setCornerRadius:10];
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    self.registerButton.backgroundColor = [UIColor colorWithHexString:@"353535" alpha:.65];
    [self.registerButton.layer setCornerRadius:10];
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [self.registerButton.titleLabel.font fontWithSize:13];
    
    self.forgotButton.backgroundColor = [UIColor colorWithHexString:@"353535" alpha:.65];
    [self.forgotButton.layer setCornerRadius:10];
    
    NSMutableAttributedString *attributedString = [self.forgotButton.currentAttributedTitle mutableCopy];
    [attributedString setAlignment:NSTextAlignmentCenter];
    [attributedString setColor:[UIColor colorWithHexString:@"68DAFF"]];
    [attributedString setFont:[self.registerButton.titleLabel.font fontWithSize:13]];
    [self.forgotButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
}

-(IBAction)loginUser:(id)sender{

    if ([self isUserCredentialsValid]) {
        
        QBUUser *user = [QBUUser user];
        user.login = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        
        [QBRequest logInWithUserLogin:user.login password:user.password successBlock:^(QBResponse *response, QBUUser *user) {
            if(response.success){
                [[LocalStorageService shared] creteCurrentUserWithQBUser:user successBlock:^(BOOL success, NSError *error) {
                    if(success){
                        [self performSegueWithIdentifier:@"unwindFromLoginScreenToInitViewScreen" sender:self];
                        //segway to next screen
                    } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
                }];
            }
        } errorBlock:^(QBResponse *response) {
           [self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."]; 
        }];
        
    } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
    
}

- (void)showAlertViewWithMeassage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    
    [alertView show];

}
-(BOOL)isUserCredentialsValid{
    return ([self isUserNameValid:self.usernameTextField.text] &&
            [self isPasswordValid:self.passwordTextField.text]);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
