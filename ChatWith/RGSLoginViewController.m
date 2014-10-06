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

@interface RGSLoginViewController ()

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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *redSquare = [UILabel new];
    redSquare.frame = CGRectMake(20, 20, 100, 100);
    redSquare.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:redSquare];

}

-(IBAction)loginUser:(id)sender{

    if ([self isUserCredentialsValid]) {
        
        [RGSUserMangementService loginUsername:self.usernameTextField.text
                            password:self.passwordTextField.text
                        successBlock:^(BOOL success) {
                            if(success){
                                
                                //segway to next screen
                            } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
                        }];
        
    } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
    
}
-(IBAction)registerUser:(id)sender{
    if ([self isUserCredentialsValid]) {
            [RGSUserMangementService isUsernameTaken:self.usernameTextField.text
                              successBlock:^(BOOL isTaken) {
                if(!isTaken){
                    [RGSUserMangementService registerUsername:self.usernameTextField.text
                                           password:self.passwordTextField.text
                                       successBlock:^(BOOL succes) {
                                           if(succes){
                                             //login user
                                               [RGSUserMangementService loginUsername:self.usernameTextField.text
                                                                   password:self.passwordTextField.text
                                                               successBlock:^(BOOL success) {
                                                   if(success) {
                                                       //loign to chat
                                                            //on success, segway to next screen
                                                       
                                                       
                                                   }
                                               }];
                                             
                                           } else {[self showAlertViewWithMeassage:@"Oops! Something's not right. Give it another shot."];}
                                       }];
                
                } else {[self showAlertViewWithMeassage:@"Oops! Somebody already has that name. Give it another shot."];}
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
