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
#import "RGSMessageListViewController.h"
#import "RGSUserMangementService.h"
#import "RGSUser.h"
#import "RGSSideMenuViewController.h"
#import "RGSInitialViewController.h"

#import "RGSMessage.h"
#import "RGSChat.h"

#import "RGSChat.h"
#import "RGSContact.h"


#import "LoremIpsum.h"

#import "RGSApplicationSessionManagementService.h"
#import "RGSContactListViewController.h"
#import "RGSChatListViewController.h"
#import "RGSChatService.h"
#import "RGSApplicationSession.h"

#import "RGSLogReport.h"
#import "RGSLogService.h"


#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "NSDate+Utilities.h"
#import "QBASession+RGSApplicationSession.h"
#import "RGSUser+QBUser.h"
#import "UILabel+RGSInitWithText.h"
#import "NSString+RGSAttributedString.h"
#import "NSString+RGSSize.h"
#import "UIView+RGSFrame.h"

#import "RGSNavigationController.h"

#import <MessageUI/MessageUI.h>



@implementation RGSAppDelegate

- (void)loginAsRRWithBarAsMessagesReceiver
{
    
    self.applicationSessionManager.applicationID = 7632;
    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
    self.applicationSessionManager.accountKey = @"byNoqE9AHiQsoffhPgdt";
    
    RGSUser *currentUser = [RGSUser MR_createEntity];
    currentUser.currentUser = [NSNumber numberWithBool:YES];
    currentUser.fullName = @"rr";
    currentUser.password = @"h5ljh4aKOcLw";
    //
    RGSUser *barUser = [RGSUser MR_createEntity];
    barUser.fullName = @"bar";
    barUser.password = @"abc123456";
    barUser.entityID = @2036179;
    //
    RGSChat *chat = [RGSChat MR_createEntity];
    chat.sender = currentUser;
    chat.receiver = barUser;
    chat.lastMessageDate = [NSDate date];
    [chat addParticipantsObject:currentUser];
    [chat addParticipantsObject:barUser];
    
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:^(BOOL success, NSError *error) {
        if (success) {
            [self.applicationSessionManager createSessionWithCompletion:^(BOOL success) {
                if (success) {
                    
                    [self.userManager loginUsername:currentUser.fullName password:currentUser.password successBlock:^(BOOL success) {
                        if (success) {
                            [[RGSChatService shared] loginUser:[[LocalStorageService shared] savedUserAsQBUUser] successBlock:^(BOOL success) {
                                if (success) {
                                    
                                    RGSMessageListViewController *mlvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//                                    mlvc.chat = chat;
//                                    mlvc.receiver = barUser;
                                    
//                                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mlvc];
                                    
                                    self.window.rootViewController = mlvc;
                                    
                                }
                                
                            }];
                        }
                        
                    }];
                    
                }
            }];
        }
    }];
}

- (void)loginAsBarWithRRAsMessagesReceiver
{
    {
        RGSUser *currentUser = [RGSUser MR_createEntity];
        currentUser.currentUser = [NSNumber numberWithBool:YES];
        currentUser.fullName = @"bar";
        currentUser.password = @"abc123456";
        
        RGSUser *rrUser = [RGSUser MR_createEntity];
        rrUser.fullName = @"rr";
        rrUser.password = @"h5ljh4aKOcLw";
        rrUser.entityID = @894248;
        
        RGSChat *chat = [RGSChat MR_createEntity];
        chat.sender = currentUser;
        chat.receiver = rrUser;
        chat.lastMessageDate = [NSDate date];
        [chat addParticipantsObject:currentUser];
        [chat addParticipantsObject:rrUser];
        
        [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:^(BOOL success, NSError *error) {
            if (success) {
                [self.applicationSessionManager createSessionWithCompletion:^(BOOL success) {
                    if (success) {
                        
                        [self.userManager loginUsername:currentUser.fullName password:currentUser.password successBlock:^(BOOL success) {
                            if (success) {
                                [[RGSChatService shared] loginUser:[[LocalStorageService shared] savedUserAsQBUUser] successBlock:^(BOOL success) {
                                    if (success) {
                                        
                                        RGSMessageListViewController *mlvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//                                        mlvc.chat = chat;
//                                        mlvc.receiver = rrUser;
                                        
                                        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mlvc];
                                        
                                        self.window.rootViewController = nc;
                                        
                                    }
                                    
                                }];
                            }
                        }];
                    }
                    
                }];
            }
        }];
        
    }
}

//-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    [MagicalRecord setupCoreDataStack];
//    
////    self.splashWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
//////    self.splashWindow .windowLevel = UIWindowLevelAlert;
////    
//////    [NSTimer bk_scheduledTimerWithTimeInterval:.3 block:^(NSTimer *timer) {
//////        self.splashWindow .windowLevel = UIWindowLevelNormal;
//////    } repeats:NO];
////    
////    RGSInitialViewController *splashViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
////    self.splashWindow.rootViewController = splashViewController;
////    [self.splashWindow makeKeyAndVisible];
//    
//    
//    RGSInitialViewController *secondSplashVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
//    
//    self.applicationSessionManager.applicationID = 7632;
//    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
//    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
//    self.applicationSessionManager.accountKey = @"byNoqE9AHiQsoffhPgdt";
//    
//    
//    
////    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
////        RGSApplicationSession *savedApplecationSession = [RGSApplicationSession MR_findFirst];
////        [savedApplecationSession MR_deleteEntity];
////        
////        RGSApplicationSession *applicationSession = [session rgsApplicationSession];
////        [applicationSession.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
////            if (success) {
////                RGSUser *savedUser = [RGSUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
////                if (savedUser) {
////                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]) {
////                        [QBRequest logInWithUserLogin:savedUser.login password:savedUser.password successBlock:^(QBResponse *response, QBUUser *user) {
////                            savedUser.entityID = [NSNumber numberWithInteger:user.ID];
////                            
////                            [savedUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
////                                [[RGSChatService shared] loginUser:[savedUser qbUser] successBlock:^(BOOL success) {
////                                    //remove top window that has splash screen
////                                    [self.window makeKeyAndVisible];
////                                    //animate splashWindow removal
////                                    [UIView animateWithDuration:.5 animations:^{
////                                        self.splashWindow.alpha = 0;
////                                    } completion:^(BOOL finished) {
////                                        if(finished)self.splashWindow = nil;
////                                    }];
////                                }];
////                            }];
////                            
////                        } errorBlock:^(QBResponse *response) {
////                            //display fatal error
////                            UIView *errorView = [self fatalErrorView];
////                            [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
////                            [self.splashWindow.rootViewController.view addSubview:errorView];
////                            
////                            [UIView animateWithDuration:.9 animations:^{
////                                [errorView setFrameOriginY:0];
////                            }];
////                            
////                            //log error
////                            RGSLogReport *logReport = [RGSLogReport MR_createEntity];
////                            logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
////                            logReport.userRequest = UserRequestLogin;
////                            logReport.failureReason = [response.error.error localizedFailureReason];
////                            [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
////                                if(success)[RGSLogService sendLog:logReport successBlock:nil];
////                            }];
////                            
////                        }];
////                    } else {
////                        
////                        self.window.rootViewController = secondSplashVC;
////                        [self.window makeKeyAndVisible];
////                        [secondSplashVC performSegueWithIdentifier:@"toLoginScreen" sender:secondSplashVC];
////
////                        [UIView animateWithDuration:.5 animations:^{
////                            self.splashWindow.alpha = 0;
////                        } completion:^(BOOL finished) {
////                            if(finished)self.splashWindow = nil;
////                        }];
////                    }
////                } else {
////                    /*
////                     added login screen to main window
////                     remove top window that has splash screen
////                     */
////                    self.window.rootViewController = secondSplashVC;
////                    [self.window makeKeyAndVisible];
////                    [secondSplashVC performSegueWithIdentifier:@"toLoginScreen" sender:secondSplashVC];
////                    
////                    [UIView animateWithDuration:9 animations:^{
////                        self.splashWindow.alpha = 0;
////                    } completion:^(BOOL finished) {
////                        if(finished)self.splashWindow = nil;
////                    }];
////                }
////               
////            } else {
////                //display fatal error
////                UIView *errorView = [self fatalErrorView];
////                [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
////                [self.splashWindow.rootViewController.view addSubview:errorView];
////                
////                [UIView animateWithDuration:.9 animations:^{
////                    [errorView setFrameOriginY:0];
////                }];
////                
////                //log error
////                RGSLogReport *logReport = [RGSLogReport MR_createEntity];
////                logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
////                logReport.userRequest = UserRequestLogin;
////                logReport.failureReason = [error localizedFailureReason];
////                [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
////                    if(success)[RGSLogService sendLog:logReport successBlock:nil];
////                }];
////            }
////        }];
////        
////    } errorBlock:^(QBResponse *response) {
////        //display fatal error
////        UIView *errorView = [self fatalErrorView];
////        [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
////        [self.splashWindow.rootViewController.view addSubview:errorView];
////        
////        [UIView animateWithDuration:.9 animations:^{
////            [errorView setFrameOriginY:0];
////        }];
////        
////        //log error
////        RGSLogReport *logReport = [RGSLogReport MR_createEntity];
////        logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
////        logReport.userRequest = UserRequestLogin;
////        logReport.failureReason = [response.error.error localizedFailureReason];
////        [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
////            if(success)[RGSLogService sendLog:logReport successBlock:nil];
////        }];
////    }];
//    return YES;
//}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return NO;
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"];
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [MagicalRecord setupCoreDataStack];
    
    //Change the alpha value of the navigation bar - technique
    //http://stackoverflow.com/questions/17460209/change-the-alpha-value-of-the-navigation-bar#17542389
    //customize the appearance of UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:
                                                      [UIColor colorWithHexString:@"414141" alpha:.85]]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    //http://stackoverflow.com/questions/12624151/mfmailcomposeviewcontroller-throws-a-viewservicedidterminatewitherror-and-then-e#18130193
//    [[UINavigationBar appearanceWhenContainedIn:[MFMailComposeViewController class], nil] setTitleTextAttributes:
//     @{
//       UITextAttributeFont : [UIFont boldSystemFontOfSize:14.0f],
//       }];
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
//    self.splashWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
//    self.splashWindow .windowLevel = UIWindowLevelStatusBar;
//    
//    [NSTimer bk_scheduledTimerWithTimeInterval:.3 block:^(NSTimer *timer) {
//        self.splashWindow .windowLevel = UIWindowLevelNormal;
//    } repeats:NO];
//    
//    RGSInitialViewController *splashViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
//    self.splashWindow.rootViewController = splashViewController;
//    [self.splashWindow makeKeyAndVisible];
//    
//    
//    UIView *errorView = [self fatalErrorView];
//    [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
//    [self.splashWindow.rootViewController.view addSubview:errorView];
//    
//    
//    [UIView animateWithDuration:.9 animations:^{
//        [errorView setFrameOriginY:0];
//    }];
//    RGSInitialViewController *secondSplashVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
//    
//    self.window.rootViewController = secondSplashVC;
//    [self.window makeKeyAndVisible];
//    [secondSplashVC performSegueWithIdentifier:@"toLoginScreen" sender:secondSplashVC];
//    
//    [UIView animateWithDuration:.9 animations:^{
//        self.splashWindow.alpha = 0;
//    } completion:^(BOOL finished) {
//        if(finished){
//            self.splashWindow = nil;
////            [self.window makeKeyAndVisible];
////            self.window.windowLevel = UIWindowLevelNormal;
//        }
//        
//    }];
    
//    [RGSUser MR_truncateAll];
//    [RGSContact MR_truncateAll];
//    [RGSMessage MR_truncateAll];
//    [RGSChat MR_truncateAll];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    
//    {
//        RGSUser *currentUser = [RGSUser MR_createEntity];
//        currentUser.currentUser = [NSNumber numberWithBool:YES];
//        currentUser.fullName = @"bar";
//        currentUser.password = @"abc123456";
//        
//        RGSUser *rrUser = [RGSUser MR_createEntity];
//        rrUser.fullName = @"rr";
//        rrUser.password = @"h5ljh4aKOcLw";
//        rrUser.entityID = @894248;
//        
//        
//        
//        for(int i = 0; i < 20; i++){
//            RGSContact *contact = [RGSContact MR_createEntity];
//            contact.source = currentUser;
//            
//            RGSUser *user = [RGSUser MR_createEntity];
//            user.fullName = [LoremIpsum word];
//            contact.friend = user;
//            
//            switch (i % 4) {
//                case 0:
//                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sarah_connor"]);
//                    user.blobID = @0;
//                    break;
//                case 1:
//                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"t1000"]);
//                    user.blobID = @1;
//                    break;
//                case 2:
//                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"joe_morton"]);
//                    user.blobID = @2;
//                    break;
//                case 3:
//                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"john_connor"]);
//                    user.blobID = @3;
//                    break;
//              default:
//                    break;
//            }
//        }
//
//        RGSChat *chat = [RGSChat MR_createEntity];
//        chat.receiver = rrUser;
//        
//        RGSMessage *m = [RGSMessage MR_createEntity];
//        m.body = [LoremIpsum wordsWithNumber:9];
//        
//        [chat addMessagesObject:m];
//        chat.lastMessageDate = [NSDate date];
//        [chat addParticipantsObject:currentUser];
//        [chat addParticipantsObject:rrUser];
//        
//        {
//        
//            RGSChat *chat = [RGSChat MR_createEntity];
//            chat.receiver = rrUser;
//            
//            RGSMessage *m = [RGSMessage MR_createEntity];
//            m.body = [LoremIpsum wordsWithNumber:9];
//            
//            [chat addMessagesObject:m];
//            chat.lastMessageDate = [NSDate date];
//            [chat addParticipantsObject:currentUser];
//            [chat addParticipantsObject:rrUser];
//        }
    
//        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//            
//            
//            self.window.frame = [[UIScreen mainScreen] bounds];
//            
//            RGSInitialViewController *splashViewController2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
//            
////            self.window.rootViewController = nil;
//            self.window.rootViewController = splashViewController2;
//            
//            
//            //    [self.window makeKeyAndVisible];
//            [self.window makeKeyAndVisible];
//            
//
//            [splashViewController2 performSegueWithIdentifier:@"toLoginScreen" sender:splashViewController2];
////            self.splashWindow = nil;
//            [UIView animateWithDuration:.5 animations:^{
//                            self.splashWindow.alpha = 0;
//                        } completion:^(BOOL finished) {
//                            if(finished)self.splashWindow = nil;
//                        }];
//        }];

//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
 
        
        
//            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//
//            if([vc isKindOfClass:[RGSSideMenuViewController class]] ||
//               [vc isKindOfClass:[RGSContactListViewController class]] ||
//               [vc isKindOfClass:[RGSMessageListViewController class]] ||
//               [vc isKindOfClass:[RGSLoginViewController class]]){
//                RGSNavigationController *nav = [[RGSNavigationController alloc] initWithRootViewController:vc];
//                self.window.rootViewController = nav;
//            } else {
//                self.window.rootViewController = vc;
//            }
   
//    }
    
//    [self loginAsRRWithBarAsMessagesReceiver];
    
    

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


-(void)applicationWillTerminate:(UIApplication *)application{
//    [[QBChat instance] logout];
//    
//    [QBRequest logOutWithSuccessBlock:nil errorBlock:nil];
}

-(void)applicationWillResignActive:(UIApplication *)application{
//    [[QBChat instance] logout];
//    
//    [QBRequest logOutWithSuccessBlock:nil errorBlock:nil];
}

-(UIView *)fatalErrorView{
    UILabel *errorMessageLabel = [UILabel labelWithText:@"An error has occured. Please report for a quicker fix."];
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    errorMessageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    errorMessageLabel.textColor = [UIColor whiteColor];
    errorMessageLabel.numberOfLines = 0;
    
    
    CGSize expectedSize = [errorMessageLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGFLOAT_MAX) font:errorMessageLabel.font].size;
    errorMessageLabel.frame = CGRectMake(10, [UIApplication sharedApplication].statusBarFrame.size.height, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, expectedSize.height);
    
    
    float errorViewHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 7 + expectedSize.height;
    UIView *errorView = [UIView new];
    errorView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), errorViewHeight);
    errorView.backgroundColor = [UIColor colorWithHexString:@"e30c28"];
    
    return errorView;
}
@end
