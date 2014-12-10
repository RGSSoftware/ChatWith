//
//  RGSInitialViewController.h
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalStorageService;

@class RGSLoginViewController;
@class RGSUserMangementService;

@class RGSApplicationSessionManagementService;

@interface RGSInitialViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)Class qBSettings;

@property (nonatomic, strong)LocalStorageService *localStorageService;

@property (nonatomic, strong)NSUserDefaults *userDefaults;
@property (nonatomic, strong)RGSApplicationSessionManagementService *applicationSessionManager;

@property (nonatomic, strong)RGSLoginViewController *loginViewController;
@property (nonatomic, strong)RGSUserMangementService *userManager;

@end
