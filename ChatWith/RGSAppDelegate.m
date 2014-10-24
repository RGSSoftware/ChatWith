//
//  RGSAppDelegate.m
//  ChatWith
//
//  Created by PC on 8/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSAppDelegate.h"
#import "LocalStorageService.h"
#import "RGSLoginViewController.h"
#import "RGSUserMangementService.h"
#import "ManagedUser.h"

#import "Converstation.h"



#import "RGSApplicationSessionManagementService.h"
#import "RGSContactListViewController.h"
#import "RGSChatService.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"

@implementation RGSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    
    //Change the alpha value of the navigation bar - technique
    //http://stackoverflow.com/questions/17460209/change-the-alpha-value-of-the-navigation-bar#17542389
    //customize the appearance of UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:
                                                      [UIColor colorWithHexString:@"414141" alpha:.85]]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    self.applicationSessionManager.applicationID = 7632;
//    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
//    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
//    self.applicationSessionManager.accountKey = @"byNoqE9AHiQsoffhPgdt";
//    
//    [self.applicationSessionManager createSessionWithCompletion:^(BOOL success) {
//        if (success) {
//            if (self.localStorageService.savedUser) {
//                if (self.localStorageService.savedUser.isSignIn) {
//                    //login user
//                    [self.userManager loginUsername:self.localStorageService.savedUser.login password:self.localStorageService.savedUser.login successBlock:^(BOOL success) {
//                        if(success){
//                            //login to chat
//                            [[RGSChatService shared] loginUser:[[LocalStorageService shared] savedUserAsQBUUser] successBlock:^(BOOL success) {
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
//                            }];
//                            
//                        } else {
//                            //retry to login 3 more times
//                            [self retryLoginWithMaxAttempts:3];
//                        }
//                    }];
//                }
//            } else {
//                self.window.rootViewController = self.loginViewController;
//            }
//        }
//    }];
    
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSContactListViewController"]];
    
    self.window.rootViewController = nc;
    return YES;
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
