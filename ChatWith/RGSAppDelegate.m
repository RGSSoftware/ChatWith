//
//  RGSAppDelegate.m
//  ChatWith
//
//  Created by PC on 8/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSAppDelegate.h"
#import "LocalStorageService.h"

@implementation RGSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self.qBSettings setApplicationID:7632];
    [self.qBSettings setAuthorizationKey:@"mxxS67kN7zNPgHn"];
    [self.qBSettings setAuthorizationSecret:@"jD6WTRWrXFm72KF"];
    
    self.window.frame = [[UIScreen mainScreen] bounds];
    if (self.localStorageService.savedUser) {
        if ([self userIsLogin]) {
            id screen = [[NSClassFromString([self.userDefaults objectForKey:@"lastVisibleViewController"]) alloc] init];
            
            if ([screen isKindOfClass:[UIViewController class]]) {
                self.window.rootViewController = (UIViewController *)screen;
            }
        }
    }
    
    [self.window makeKeyAndVisible];
    return YES;
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
@end
