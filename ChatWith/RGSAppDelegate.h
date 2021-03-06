//
//  RGSAppDelegate.h
//  ChatWith
//
//  Created by PC on 8/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocalStorageService;

@class RGSLoginViewController;
@class RGSUserMangementService;

@class RGSApplicationSessionManagementService;



@interface RGSAppDelegate : UIResponder <UIApplicationDelegate, QBActionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *splashWindow;

@property (nonatomic,strong)Class qBSettings;

@property (nonatomic, strong)LocalStorageService *localStorageService;

@property (nonatomic, strong)NSUserDefaults *userDefaults;
@property (nonatomic, strong)RGSApplicationSessionManagementService *applicationSessionManager;

@property (nonatomic, strong)RGSLoginViewController *loginViewController;
@property (nonatomic, strong)RGSUserMangementService *userManager;

@end
