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
#import "RGSUserLoginDelegate.h"

#import "RGSApplicationSessionManagementService.h"

@implementation RGSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.applicationSessionManager.applicationID = 7632;
    self.applicationSessionManager.authorizationKey = @"mxxS67kN7zNPgHn";
    self.applicationSessionManager.authorizationSecret = @"jD6WTRWrXFm72KF";
    
    [self.applicationSessionManager createSessionWithCompletion:^(BOOL success) {
        if (success) {
            if (self.localStorageService.savedUser) {
                if ([self userIsLogin]) {
                    //retore last Visible screen
                    
//                    id screen = [[NSClassFromString([self.userDefaults objectForKey:@"lastVisibleViewController"]) alloc] init];
//                    
//                    if ([screen isKindOfClass:[UIViewController class]]) {
//                        self.window.rootViewController = (UIViewController *)screen;
                }
            } else {
                self.loginViewController.delegate = self.userLoginDelegate;
                self.window.rootViewController = self.loginViewController;
            }
        } else {
            
        }
    }];
    
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    return YES;
}

-(RGSApplicationSessionManagementService *)applicationSessionManager{
    if (_applicationSessionManager == nil)
    {
        _applicationSessionManager = [RGSApplicationSessionManagementService new];
    }
    return _applicationSessionManager;
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

-(NSUserDefaults *)userDefaults{
    return [NSUserDefaults standardUserDefaults];
}

-(LocalStorageService *)localStorageService{
    return [LocalStorageService shared];
}

-(BOOL)userIsLogin{
    QBUUser *user = self.localStorageService.savedUser;
    
    if (user.login && user.password && [[self.userDefaults objectForKey:@"isAutoLogin"] boolValue]) {
        return YES;
    }
    return NO;
}

-(RGSLoginViewController *)loginViewController{
    if (_loginViewController == nil)
    {
        _loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];;
    }
    return _loginViewController;
}

-(RGSUserLoginDelegate *)userLoginDelegate{
    if (_userLoginDelegate == nil)
    {
        _userLoginDelegate = [RGSUserLoginDelegate new];
    }
    return _userLoginDelegate;
}
@end
