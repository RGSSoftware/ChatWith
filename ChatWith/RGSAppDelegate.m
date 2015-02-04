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

#import "RGSMessageComposerView.h"


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

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [MagicalRecord setupCoreDataStack];

    self.splashWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
    self.splashWindow .windowLevel = UIWindowLevelAlert;

    [NSTimer bk_scheduledTimerWithTimeInterval:.3 block:^(NSTimer *timer) {
        self.splashWindow .windowLevel = UIWindowLevelNormal;
    } repeats:NO];

    RGSInitialViewController *splashViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
    self.splashWindow.rootViewController = splashViewController;
    [self.splashWindow makeKeyAndVisible];


    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self deleteDataModel];
    
    [self configAppearance];
    
    self.window.frame = [UIScreen mainScreen].bounds;
    
    
    
    [RGSApplicationSessionManagementService shared].applicationID = 7632;
    [RGSApplicationSessionManagementService shared].authorizationKey = @"mxxS67kN7zNPgHn";
    [RGSApplicationSessionManagementService shared].authorizationSecret = @"jD6WTRWrXFm72KF";
    [RGSApplicationSessionManagementService shared].accountKey = @"byNoqE9AHiQsoffhPgdt";
    
    
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        RGSApplicationSession *savedApplecationSession = [RGSApplicationSession MR_findFirst];
        [savedApplecationSession MR_deleteEntity];
        
        RGSApplicationSession *applicationSession = [session rgsApplicationSession];
        [applicationSession.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            if (success) {
                RGSUser *savedUser = [RGSUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
                if (savedUser) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]) {
                        [QBRequest logInWithUserLogin:savedUser.login password:savedUser.password successBlock:^(QBResponse *response, QBUUser *user) {
                            savedUser.entityID = [NSNumber numberWithInteger:user.ID];
                            
                            [savedUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                                [[RGSChatService shared] loginUser:[savedUser qbUser] successBlock:^(BOOL success) {
                                    //remove top window that has splash screen
                                    
                                    //animate splashWindow removal
                                    [UIView animateWithDuration:.5 animations:^{
                                        self.splashWindow.alpha = 0;
                                    } completion:^(BOOL finished) {
                                        if(finished){
                                            self.splashWindow = nil;
                                            [self.window makeKeyAndVisible];
                                        }
                                    }];
                                }];
                            }];
                        } errorBlock:^(QBResponse *response) {
                            [self handleFatalError:response.error.error];
                        }];
                    } else {
                        [self showLoginScreen];
                    }
                } else {
                    [self showLoginScreen];
                }
            } else {
                [self handleFatalError:error];
            }
        }];
    } errorBlock:^(QBResponse *response) {
        [self handleFatalError:response.error.error];
    }];
    
    [self deleteDataModel];
    //    [self createDataModel];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"];
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return NO;
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

- (void)configAppearance
{
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
}

-(void)deleteDataModel{
    [RGSUser MR_truncateAll];
    [RGSContact MR_truncateAll];
    [RGSMessage MR_truncateAll];
    [RGSChat MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

-(void)createDataModel{
    
    RGSUser *rrUser = [RGSUser MR_createEntity];
    rrUser.fullName = @"rr";
    rrUser.password = @"h5ljh4aKOcLw";
    rrUser.entityID = @894248;
    rrUser.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"terminator"]);
    rrUser.currentUser = [NSNumber numberWithBool:YES];
    
    for(int i = 0; i < 4; i++){
        
        RGSUser *user = [RGSUser MR_createEntity];
        switch (i % 4) {
            case 0:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sarah_connor"]);
                user.fullName = @"sarah";
                break;
            case 1:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"t1000"]);
                user.fullName = @"t1000";
                break;
            case 2:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"joe_morton"]);
                user.fullName = @"joe";
                break;
            case 3:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"john_connor"]);
                user.fullName = @"john";
                break;
            default:
                break;
        }
        
        RGSContact *contact = [RGSContact MR_createEntity];
        contact.source = rrUser;
        contact.friend = user;
        
        RGSChat *chat = [RGSChat MR_createEntity];
        chat.receiver = rrUser;
        [chat addParticipantsObject:rrUser];
        [chat addParticipantsObject:user];
        
        int rand = arc4random_uniform(30) + 1;
        for(int i = 0; i < rand; i++){
            RGSMessage *m = [RGSMessage MR_createEntity];
            m.body = [LoremIpsum wordsWithNumber:(arc4random_uniform(30) + 1)];
            switch (i % 2) {
                case 0:
                    m.receiver = user;
                    m.sender = rrUser;
                    break;
                case 1:
                    m.receiver = rrUser;
                    m.sender = user;
                    break;
                default:
                    break;
            }
            [chat addMessagesObject:m];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    
}
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

- (void)handleFatalError:(NSError *)error
{
    //display fatal error
    UIView *errorView = [self fatalErrorView];
    [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
    [[[[UIApplication sharedApplication] keyWindow] addSubview:someView] addSubview:errorView];
    
    [UIView animateWithDuration:.9 animations:^{
        [errorView setFrameOriginY:0];
    }];
    
    //log error
    RGSLogReport *logReport = [RGSLogReport MR_createEntity];
    logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    logReport.userRequest = UserRequestLogin;
    logReport.failureReason = [error localizedFailureReason];
    [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        if(success)[RGSLogService sendLog:logReport successBlock:nil];
    }];
}

- (void)showLoginScreen
{
    /*
     added login screen to main window
     remove top window that has splash screen
     */
    
    RGSInitialViewController *secondSplashVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
    
    self.window.rootViewController = secondSplashVC;
    [secondSplashVC performSegueWithIdentifier:@"toLoginScreen" sender:secondSplashVC];
    
    [UIView animateWithDuration:9 animations:^{
        self.splashWindow.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [self.window makeKeyAndVisible];
            self.splashWindow = nil;
        }
    }];
}


@end
