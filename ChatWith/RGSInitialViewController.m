//
//  RGSInitialViewController.m
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSInitialViewController.h"

#import "LocalStorageService.h"
#import "RGSLoginViewController.h"
#import "RGSMessageListViewController.h"
#import "RGSUserMangementService.h"
#import "RGSManagedUser.h"

#import "RGSMessage.h"
#import "RGSChat.h"

#import "RGSChat.h"
#import "RGSContact.h"

#import "NSDate+Utilities.h"

#import "LoremIpsum.h"

#import "ApplicationSession.h"

#import "RGSApplicationSessionManagementService.h"
#import "RGSContactListViewController.h"
#import "RGSChatService.h"


#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"

@interface RGSInitialViewController ()

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
    [super viewDidAppear:animated];
    
    self.applicationSessionManager.applicationID = 7632;
    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
    self.applicationSessionManager.accountKey = @"byNoqE9AHiQsoffhPgdt";
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [[self localStorageService].applicationSession MR_deleteEntity];
        [[LocalStorageService shared] crateApplicationSessionWithQBASession:session successBlock:^(BOOL success, NSError *error) {
            if (success) {
                if (self.localStorageService.savedUser) {
                    
                    if (self.localStorageService.savedUser.isSignIn) {
                        //login user
                        [self.userManager loginUsername:self.localStorageService.savedUser.login password:self.localStorageService.savedUser.password successBlock:^(BOOL success) {
                            if(success){
                                //login to chat
                                [[RGSChatService shared] loginUser:[[LocalStorageService shared] savedUserAsQBUUser] successBlock:^(BOOL success) {
                                    //                                if(success){
                                    //                                    //retrieve lastest Converstations From QuickBlox
                                    //                                    //starting from lastest saved conversation
                                    //                                    [[RGSChatService shared] allConversationsFromUser:[[LocalStorageService shared] savedUser] startingAt:[LocalStorageService shared].lastestConverstation.lastMessageDate successBlock:^(BOOL success, NSArray *conversations) {
                                    //                                        if(success) {
                                    //                                            //save converstations to LocalStorage
                                    //                                            [[LocalStorageService shared] saveConversations:conversations];
                                    //                                            //on success, retore last visible screen
                                    //                                        }
                                    //                                    }];
                                    //                                }
                                }];
                                
                            } else {
                                //retry to login 3 more times
                                [self retryLoginWithMaxAttempts:3];
                            }
                        }];
                    } else {
                        //show loginScreen
                        //with userName and password in present in fields
                    }
                } else {
                    [self performSegueWithIdentifier:@"toLoginScreen" sender:self];
                }
            }
        }];
    } errorBlock:^(QBResponse *response) {
        
    }];
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
    
}
-(RGSApplicationSessionManagementService *)applicationSessionManager{
    return [RGSApplicationSessionManagementService shared];
}

-(RGSUserMangementService *)userManager{
    return [RGSUserMangementService shared];
    
}

-(Class)qBSettings{
    if (_qBSettings == nil)
    {
        _qBSettings = [QBSettings class];
    }
    return _qBSettings;
}

-(UIWindow *)window{
    if (_window == nil)
    {
        _window = [[UIWindow alloc] init];
    }
    return _window;
}

-(LocalStorageService *)localStorageService{
    return [LocalStorageService shared];
}

-(RGSLoginViewController *)loginViewController{
    if (_loginViewController == nil)
    {
        _loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];;
    }
    return _loginViewController;
}
@end
