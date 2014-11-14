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
#import "RGSManagedUser.h"

#import "RGSMessage.h"
#import "RGSChat.h"

#import "RGSChat.h"
#import "RGSContact.h"

#import "NSDate+Utilities.h"

#import "LoremIpsum.h"



#import "RGSApplicationSessionManagementService.h"
#import "RGSContactListViewController.h"
#import "RGSChatService.h"
#import "RGSMessageListViewControllerOnePop.h"

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
    
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];//change the color to whichever color needed
    
    [RGSManagedUser MR_truncateAll];
    [RGSContact MR_truncateAll];
    [RGSMessage MR_truncateAll];
    [RGSChat MR_truncateAll];
//
    RGSManagedUser *currentUser = [RGSManagedUser MR_createEntity];
    currentUser.currentUser = [NSNumber numberWithBool:YES];
//
////    for(int i = 0; i < 60; i++){
////        RGSManagedUser *testUser = [RGSManagedUser MR_createEntity];
////        testUser.fullName = @"test";
////        
////        Contact *contacTest = [Contact MR_createEntity];
////        contacTest.source = currentUser;
////        contacTest.friend = testUser;
////        
////        [currentUser addContactsObject:contacTest];
////    }
//    
//    /////////////
    RGSManagedUser *barUser = [RGSManagedUser MR_createEntity];
    barUser.fullName = @"bar";
    
    RGSContact *contactBar = [RGSContact MR_createEntity];
    contactBar.source = currentUser;
    contactBar.friend = barUser;
    
    [currentUser addContactsObject:contactBar];
//    //////////////
//    RGSManagedUser *fooUser = [RGSManagedUser MR_createEntity];
//    fooUser.fullName = @"foo";
//    
//    RGSContact *contactFoo = [RGSContact MR_createEntity];
//    contactFoo.source = currentUser;
//    contactFoo.friend = fooUser;
//    
//    [currentUser addContactsObject:contactFoo];
//    ///////////////////
//    RGSManagedUser *teeUser = [RGSManagedUser MR_createEntity];
//    teeUser.fullName = @"tee";
//    
//    RGSContact *contactTee = [RGSContact MR_createEntity];
//    contactTee.source = currentUser;
//    contactTee.friend = teeUser;
//    
//    [currentUser addContactsObject:contactTee];
//    /////////////////
//    RGSManagedUser *weeUser = [RGSManagedUser MR_createEntity];
//    weeUser.fullName = @"wee";
//    
//    RGSContact *contactWee = [RGSContact MR_createEntity];
//    contactWee.source = teeUser;
//    contactWee.friend = weeUser;
//    
//    [teeUser addContactsObject:contactWee];
//    
//    
//    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil];
    
    RGSChat *chat1 = [RGSChat MR_createEntity];
    chat1.sender = currentUser;
    chat1.receiver = barUser;
    chat1.lastMessageDate = [NSDate date];
    [chat1 addParticipantsObject:currentUser];
    
//    for (int i = 0; i < 10; i++) {
//        RGSMessage *message = [RGSMessage MR_createEntity];
//        message.body = @"Lorem ipsum dolor sit amet, cu wisi inimicus gloriatur nec. Vis id falli eripuit. Ius nusquam detraxit senserit cu, te.";
//        message.date = [NSDate date];
//        [chat1 addMessagesObject:message];
//    }
    
    {
        RGSMessage *message = [RGSMessage MR_createEntity];
        message.body = @"a Message to current User sent";
        message.date = [[NSDate dateYesterday] dateByAddingHours:3];
        message.sender = currentUser;
        [chat1 addMessagesObject:message];
    }

    {
        RGSMessage *message = [RGSMessage MR_createEntity];
        message.body = @"a Message to Bar sent";
        message.date = [[NSDate dateYesterday] dateByAddingHours:3];
        message.sender = barUser;
        [chat1 addMessagesObject:message];
    }
    {
        RGSMessage *message = [RGSMessage MR_createEntity];
        message.body = [LoremIpsum wordsWithNumber:19];
        message.date = [[NSDate dateYesterday] dateByAddingHours:3];
        message.sender = currentUser;
        [chat1 addMessagesObject:message];
    }
    {
        RGSMessage *message = [RGSMessage MR_createEntity];
        message.body = @"two words";
        message.date = [[NSDate dateYesterday] dateByAddingHours:3];
        message.sender = currentUser;
        [chat1 addMessagesObject:message];
    }

    [currentUser addChatsObject:chat1];
    
    for (int i = 0; i < 3; i ++) {
        RGSChat *chat = [RGSChat MR_createEntity];
        chat.sender = currentUser;
        [chat addParticipantsObject:currentUser];
        
        if (i == 0) {
            chat.lastMessageDate = [NSDate dateYesterday];
        } else if (i == 1){
            chat.lastMessageDate = [NSDate dateWithDaysBeforeNow:2];
        } else if (i == 2){
            chat.lastMessageDate = [NSDate dateWithDaysBeforeNow:40];
        }
        [currentUser addChatsObject:chat];
    }
    
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:^(BOOL success, NSError *error) {
        if (success) {
            
//            RGSMessageListViewController *mlvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSMessageListViewController"];
//            mlvc.chat = chat1;
//            
//            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mlvc];
//            //
//                self.window.rootViewController = nc;
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSChatListViewController"]];
            
            self.window.rootViewController = nc;

        }
    }];

////
    NSLog(@"simple print-----allUsers.count------{%lu}", (unsigned long)[[RGSManagedUser MR_findAll] count]);
    NSLog(@"simple print-----allContacts.count------{%lu}", (unsigned long)[[RGSContact MR_findAll] count]);
    NSLog(@"simple print-----allChats.count------{%lu}", (unsigned long)[[RGSChat MR_findAll] count]);
    NSLog(@"simple print-----allMessage.count------{%lu}", (unsigned long)[[RGSMessage MR_findAll] count]);

    
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
//
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSChatListViewController"]];
//    
//    self.window.rootViewController = nc;
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
