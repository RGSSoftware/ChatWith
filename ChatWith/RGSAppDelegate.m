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
#import "RGSManagedUser.h"
#import "RGSSideMenuViewController.h"

#import "RGSMessage.h"
#import "RGSChat.h"

#import "RGSChat.h"
#import "RGSContact.h"

#import "LoremIpsum.h"

#import "RGSApplicationSessionManagementService.h"
#import "RGSContactListViewController.h"
#import "RGSChatListViewController.h"
#import "RGSChatService.h"


#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "NSDate+Utilities.h"

#import "RGSNavigationController.h"

#import <MessageUI/MessageUI.h>



@implementation RGSAppDelegate

- (void)loginAsRRWithBarAsMessagesReceiver
{
    
    self.applicationSessionManager.applicationID = 7632;
    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
    self.applicationSessionManager.accountKey = @"byNoqE9AHiQsoffhPgdt";
    
    RGSManagedUser *currentUser = [RGSManagedUser MR_createEntity];
    currentUser.currentUser = [NSNumber numberWithBool:YES];
    currentUser.fullName = @"rr";
    currentUser.password = @"h5ljh4aKOcLw";
    //
    RGSManagedUser *barUser = [RGSManagedUser MR_createEntity];
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
        RGSManagedUser *currentUser = [RGSManagedUser MR_createEntity];
        currentUser.currentUser = [NSNumber numberWithBool:YES];
        currentUser.fullName = @"bar";
        currentUser.password = @"abc123456";
        
        RGSManagedUser *rrUser = [RGSManagedUser MR_createEntity];
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
    
    //http://stackoverflow.com/questions/12624151/mfmailcomposeviewcontroller-throws-a-viewservicedidterminatewitherror-and-then-e#18130193
//    [[UINavigationBar appearanceWhenContainedIn:[MFMailComposeViewController class], nil] setTitleTextAttributes:
//     @{
//       UITextAttributeFont : [UIFont boldSystemFontOfSize:14.0f],
//       }];
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [RGSManagedUser MR_truncateAll];
    [RGSContact MR_truncateAll];
    [RGSMessage MR_truncateAll];
    [RGSChat MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    
    {
        RGSManagedUser *currentUser = [RGSManagedUser MR_createEntity];
        currentUser.currentUser = [NSNumber numberWithBool:YES];
        currentUser.fullName = @"bar";
        currentUser.password = @"abc123456";
        
        RGSManagedUser *rrUser = [RGSManagedUser MR_createEntity];
        rrUser.fullName = @"rr";
        rrUser.password = @"h5ljh4aKOcLw";
        rrUser.entityID = @894248;
        
        
        
        for(int i = 0; i < 20; i++){
            RGSContact *contact = [RGSContact MR_createEntity];
            contact.source = currentUser;
            
            RGSManagedUser *user = [RGSManagedUser MR_createEntity];
            user.fullName = [LoremIpsum word];
            contact.friend = user;
            
            switch (i % 4) {
                case 0:
                user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"sarah_connor"]);
                    user.blobID = @0;
                    break;
                case 1:
                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"t1000"]);
                    user.blobID = @1;
                    break;
                case 2:
                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"joe_morton"]);
                    user.blobID = @2;
                    break;
                case 3:
                    user.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"john_connor"]);
                    user.blobID = @3;
                    break;
              default:
                    break;
            }
        }

        RGSChat *chat = [RGSChat MR_createEntity];
        chat.receiver = rrUser;
        
        RGSMessage *m = [RGSMessage MR_createEntity];
        m.body = [LoremIpsum wordsWithNumber:9];
        
        [chat addMessagesObject:m];
        chat.lastMessageDate = [NSDate date];
        [chat addParticipantsObject:currentUser];
        [chat addParticipantsObject:rrUser];
        
        {
        
            RGSChat *chat = [RGSChat MR_createEntity];
            chat.receiver = rrUser;
            
            RGSMessage *m = [RGSMessage MR_createEntity];
            m.body = [LoremIpsum wordsWithNumber:9];
            
            [chat addMessagesObject:m];
            chat.lastMessageDate = [NSDate date];
            [chat addParticipantsObject:currentUser];
            [chat addParticipantsObject:rrUser];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

 
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];

            if([vc isKindOfClass:[RGSSideMenuViewController class]] ||
               [vc isKindOfClass:[RGSContactListViewController class]] ||
               [vc isKindOfClass:[RGSMessageListViewController class]] ||
               [vc isKindOfClass:[RGSLoginViewController class]]){
                RGSNavigationController *nav = [[RGSNavigationController alloc] initWithRootViewController:vc];
                self.window.rootViewController = nav;
            } else {
                self.window.rootViewController = vc;
            }
   
    }
    
//    [self loginAsRRWithBarAsMessagesReceiver];
    
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];

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
@end
