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
#import "RGSImage.h"
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



#import "QBASession+RGSApplicationSession.h"
#import "RGSChat+RGSManagement.h"

#import "RGSNavigationController.h"

#import <MessageUI/MessageUI.h>
@implementation RGSAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [MagicalRecord setupCoreDataStack];
    
    [self deleteDataModel];
    [self createDataModel];
    
    [self configAppearance];
//
//    self.splashWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
//    self.splashWindow .windowLevel = UIWindowLevelAlert;
//
//    [NSTimer bk_scheduledTimerWithTimeInterval:.3 block:^(NSTimer *timer) {
//        self.splashWindow .windowLevel = UIWindowLevelNormal;
//    } repeats:NO];
//
//    RGSInitialViewController *splashViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
//    self.splashWindow.rootViewController = splashViewController;
//    [self.splashWindow makeKeyAndVisible];


    
    return YES;
}

- (void)addMessageListToWindow
{
    RGSMessageListViewController *messageListViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSMessageListViewController"];
    messageListViewController.chat = [RGSChat MR_findFirst];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:messageListViewController];
    
    self.window.rootViewController = nvc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UDKAutoLogin];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UDKRememberMe];
    
    
    
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    [self addMessageListToWindow];
    
    
    
    [RGSApplicationSessionManagementService shared].applicationID = 7632;
    [RGSApplicationSessionManagementService shared].authorizationKey = @"mxxS67kN7zNPgHn";
    [RGSApplicationSessionManagementService shared].authorizationSecret = @"jD6WTRWrXFm72KF";
    [RGSApplicationSessionManagementService shared].accountKey = @"byNoqE9AHiQsoffhPgdt";
    
    
    
//    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
////        RGSApplicationSession *savedApplecationSession = [RGSApplicationSession MR_findFirst];
////        if(savedApplecationSession) [savedApplecationSession MR_deleteEntity];
//        
//        
//        RGSApplicationSession *applicationSession = [session rgsApplicationSession];
//        [applicationSession.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//            if (success) {
//                RGSUser *savedUser = [RGSUser findCurrentUser];
//                if (savedUser) {
//                    if ([[NSUserDefaults standardUserDefaults] boolForKey:UDKAutoLogin]) {
//                        [QBRequest logInWithUserLogin:savedUser.login password:savedUser.password successBlock:^(QBResponse *response, QBUUser *user) {
//                            savedUser.entityID = [NSNumber numberWithInteger:user.ID];
//                            
//                            [savedUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//                                [[RGSChatService shared] loginUser:[savedUser qbUser] successBlock:^(BOOL success) {
//                                    //remove top window that has splash screen
//                                    
//                                    //animate splashWindow removal
//                                    [UIView animateWithDuration:.5 animations:^{
//                                        self.splashWindow.alpha = 0;
//                                    } completion:^(BOOL finished) {
//                                        if(finished){
//                                            self.splashWindow = nil;
//                                            [self.window makeKeyAndVisible];
//                                        }
//                                    }];
//                                }];
//                            }];
//                        } errorBlock:^(QBResponse *response) {
//                            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                            [errorDetail setValue:@"error login to QBSystem" forKey:NSLocalizedFailureReasonErrorKey];
//                            [errorDetail setValue:@"Couldn't complete login of user because there was a QBSystem failure login." forKey:NSLocalizedDescriptionKey];
//                            ;
//                            [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail], LogReportLevelSub : response.error.error}];
//                        }];
//                    } else {
//                        [self showLoginScreen];
//                    }
//                } else {
//                    [self showLoginScreen];
//                }
//            } else {
//                
//                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                [errorDetail setValue:@"error saving the application session" forKey:NSLocalizedFailureReasonErrorKey];
//                [errorDetail setValue:@"Couldn't complete login of user because there was an error saving the Application Session." forKey:NSLocalizedDescriptionKey];
//               ;
//                [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ESAS userInfo:errorDetail], LogReportLevelSub : error}];
//            }
//        }];
//    } errorBlock:^(QBResponse *response) {
//        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//        [errorDetail setValue:@"error creating an application session" forKey:NSLocalizedFailureReasonErrorKey];
//        [errorDetail setValue:@"Couldn't complete login of user because couldn't create an application session." forKey:NSLocalizedDescriptionKey];
//        ;
//        [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ECAS userInfo:errorDetail], LogReportLevelSub : response.error.error}];
//    }];

    
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return [[NSUserDefaults standardUserDefaults] boolForKey:UDKAutoLogin];
    #warning remove this before build - i'm doing this beuase i think when the app start, it;s trying to restrore the view hiech and not just init the viwe from storyboard
    return NO;
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
    rrUser.login = @"rr";
    rrUser.password = @"h5ljh4aKOcLw";
    rrUser.entityID = @894248;
    rrUser.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"terminator"]);
    rrUser.currentUser = [NSNumber numberWithBool:YES];
    
    for(int i = 0; i < 4; i++){
        
        RGSUser *user = [RGSUser MR_createEntity];
        switch (i % 4) {
            case 0:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sarah_connor"]);
                user.login = @"sarah";
                user.fullName = @"sarah";
                break;
            case 1:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"t1000"]);
                user.login = @"t1000";
                user.fullName = @"t1000";
                break;
            case 2:
//                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"joe_morton"]);
                user.login = @"joe";
                user.fullName = @"joe";
                break;
            case 3:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"john_connor"]);
                user.login = @"john";
                user.fullName = @"john";
                break;
            default:
                break;
        }
        
        RGSContact *contact = [RGSContact MR_createEntity];
        contact.source = rrUser;
        contact.friend = user;
        
        RGSChat *chat = [RGSChat RGS_createEntity];
        chat.receiver = rrUser;
        [chat addParticipantsObject:rrUser];
        [chat addParticipantsObject:user];
        
        int rand = arc4random_uniform(30) + 1;
//        if(i == 0){
//            rand = 1;
//        }
        for(int j = 0; j < rand; j++){
            
            RGSMessage *m = [RGSMessage MR_createEntity];
            m.date = [NSDate dateWithDaysBeforeNow:20];
            m.body = [LoremIpsum wordsWithNumber:(arc4random_uniform(30) + 1)];
            switch (j % 2) {
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
            RGSImage *image = [RGSImage MR_createEntity];
            if(j == (rand - 1)){
                switch (i % 4) {
                    case 0:
                    {
                        
                
                        m.date = [NSDate date];
                        m.isUnread = @(YES);
                        
                        
                        m.chat = chat;
                        m.body = [NSString stringWithUTF8String:"\ufffc"];
                        //    message.sendStatus = SendStatusSending;
                        
                        
                        image.imageData = UIImagePNGRepresentation([[UIImage imageNamed:@"terminator"] resizedImage:CGSizeMake(80,140)]);
                        image.index = @0;
//                        image.message = m;

                        m.image = image;
                        
                        
//                        NSMutableArray *messageImages = [NSMutableArray new];
//                        for(RGSMessageComposeImage *sortedImage in self.messageComposeImages){
//                            RGSImage *image = [RGSImage MR_createEntity];
//                            image.imageData = UIImageJPEGRepresentation(sortedImage.image,0.0);
//                            image.index = [NSNumber numberWithInteger:sortedImage.index];
//                            image.message = message;
//
//                            [message addImagesObject:image];
//                            
//                            RGSMessage *messageImage = [RGSMessage MR_createEntity];
//                            messageImage.sender = self.currentUser;
//                            messageImage.receiver = self.receiver;
//                            messageImage.chat = self.chat;
//                            messageImage.body = [NSString stringWithUTF8String:"\ufffc"];
//                            messageImage.image = image;
//                            
//                            image.messageImage = messageImage;
//                            
//                            [messageImages addObject:messageImages];
//                        }

                        
                    }
                        break;
                    case 1:
                        m.date = [NSDate dateYesterday];
                        m.isUnread = @(YES);
                        break;
                    case 2:
                        m.date = [NSDate dateWithDaysBeforeNow:2];
                        m.isUnread = @(YES);
                        break;
                    case 3:
                        m.date = [NSDate dateWithDaysBeforeNow:8];
                         m.isUnread = @(YES);

                        break;
                    default:
                        break;
                }
            }
            [chat addMessagesObject:m];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
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
        currentUser.fullName = @"rr";
        currentUser.password = @"h5ljh4aKOcLw";
        currentUser.entityID = @894248;
        
        RGSUser *rrUser = [RGSUser MR_createEntity];
        rrUser.fullName = @"bar";
        rrUser.password = @"abc123456";
        
        RGSChat *chat = [RGSChat MR_createEntity];
        chat.sender = currentUser;
        chat.receiver = rrUser;
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

-(void)handleFatalError:(NSDictionary *)errorDic{
    //display fatal error
    UIView *errorView = [self fatalErrorView];
    [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
    [[[UIApplication sharedApplication] keyWindow] addSubview:errorView];
    
    [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [errorView setFrameOriginY:0];
    } completion:nil];
    
    RGSLogReport *logReport = [RGSLogReport logReportFromErrorDic:errorDic];
    if(logReport){
        [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            if(success)[RGSLogService sendLog:logReport successBlock:nil];
        }];
    }}

- (void)showLoginScreen
{
    /*
     added login screen to main window
     remove top window that has splash screen
     */
    
    RGSInitialViewController *secondSplashVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSInitialViewController"];
    
    self.window.rootViewController = secondSplashVC;
    [secondSplashVC performSegueWithIdentifier:@"toLoginScreen" sender:secondSplashVC];
    
    [UIView animateWithDuration:.9 animations:^{
        self.splashWindow.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [self.window makeKeyAndVisible];
            self.splashWindow = nil;
        }
    }];
}


@end
