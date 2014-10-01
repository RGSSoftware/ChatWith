//
//  RGSLoginViewController.m
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSLoginViewController.h"
//#import "UserModel.h"
#import "NSString+alphaOnly.h"

@interface RGSLoginViewController ()

@end

@implementation RGSLoginViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *redSquare = [UILabel new];
    redSquare.frame = CGRectMake(20, 20, 100, 100);
    redSquare.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:redSquare];

}

-(IBAction)loginUser:(id)sender{
    if ([self isUserCredentialsValid]) {
        if ([self.delegate respondsToSelector:@selector(loginViewController:loginUsername:password:)]) {
            [self.delegate loginViewController:self
                                 loginUsername:self.usernameTextField.text
                                      password:self.passwordTextField.text];
        }
    } else{
        UIAlertView *alertView = [[_alertViewClass alloc] initWithTitle:nil
                                                                message:@"Oops! Something's not right. Give it another shot."
                                                               delegate:self
                                                      cancelButtonTitle:@"OKAY"
                                                      otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(IBAction)registerUser:(id)sender{
    
    if ([self isUserCredentialsValid]) {
        if ([self.delegate respondsToSelector:@selector(loginViewController:registerUsername:password:)]) {
            [self.delegate loginViewController:self
                              registerUsername:self.usernameTextField.text
                                      password:self.passwordTextField.text];
        }
    }
#warning imp diolog box to user when username is taken
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
