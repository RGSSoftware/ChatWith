//
//  RGSInitialViewController.m
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSInitialViewController.h"

#import "RGSLoginViewController.h"
#import "RGSMessageListViewController.h"
#import "RGSContactListViewController.h"

#import "LocalStorageService.h"
#import "RGSUserMangementService.h"
#import "RGSApplicationSessionManagementService.h"
#import "RGSChatService.h"

#import "RGSUser.h"
#import "RGSMessage.h"
#import "RGSChat.h"
#import "RGSContact.h"
#import "RGSApplicationSession.h"

#import "LoremIpsum.h"

@interface RGSInitialViewController ()

@property BOOL shouldGoToMainApp;
@end

@implementation RGSInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.shouldGoToMainApp) [self performSegueWithIdentifier:@"toMainApp" sender:self];
     
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


}

-(void)retryLoginWithMaxAttempts:(int)tries{
    [self.userManager loginUsername:self.localStorageService.savedUser.login password:self.localStorageService.savedUser.login successBlock:^(BOOL success) {
        __block int currentTry = tries;
        
        if(success){
            //login to chat
            [[RGSChatService shared] loginUser:[[LocalStorageService shared] savedUserAsQBUUser] successBlock:^(BOOL success) {
                
                //on success, retore last visible screen
                if(success){
                    
                }
            }];
        } else {
            if(currentTry != 0){
                currentTry--;
                [self retryLoginWithMaxAttempts:currentTry];
            } else {
                //after 3 tries and still not success
                
                //show loginViewController
                self.window.rootViewController = self.loginViewController;
            }
        }
    }];
}


- (IBAction)unwindToInitViewController:(UIStoryboardSegue *)unwindSegue
{
    self.shouldGoToMainApp = YES;
}
@end
