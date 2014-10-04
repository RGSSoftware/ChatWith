//
//  RGSAppDelegateSpec.m
//  ChatWith
//
//  Created by PC on 8/25/14.
//  Copyright 2014 Randel Smith. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RGSAppDelegate.h"
#import "LocalStorageService.h"

#import "RGSLoginViewController.h"

#import "userMangementService.h"

static BOOL applicationDidFinshLaunchingFrom(RGSAppDelegate *sut)
{
    return [sut application:nil didFinishLaunchingWithOptions:nil];
    
}

SPEC_BEGIN(RGSAppDelegateSpec)

describe(@"RGSAppDelegate", ^{
    __block RGSAppDelegate *sut;
    
    beforeEach(^{
        sut = [[RGSAppDelegate alloc] init];
    });
    afterEach(^{
        sut = nil;
    });
    
    describe(@"events", ^{
        context(@"applicationDidFinishLaunchingWithOptions", ^{
            
            describe(@"qBSetting", ^{
                __block Class mockQBSettings;
                beforeEach(^{
                    mockQBSettings = [QBSettings nullMock];
                    [sut stub:@selector(qBSettings) andReturn:mockQBSettings];
                });
                afterEach(^{
                    mockQBSettings = nil;
                });
                it(@"ApplicationID should be", ^{
                    [[mockQBSettings should] receive:@selector(setApplicationID:) withArguments:@7632];
                    
                    applicationDidFinshLaunchingFrom(sut);
                    
                });
                it(@"AuthorizationKey should be", ^{
                    [[mockQBSettings should] receive:@selector(setAuthorizationKey:) withArguments:@"mxxS67kN7zNPgHn"];
                    
                    applicationDidFinshLaunchingFrom(sut);
                });
                it(@"AuthorizationSecret should be", ^{
                    [[mockQBSettings should] receive:@selector(setAuthorizationSecret:) withArguments:@"jD6WTRWrXFm72KF"];
                    
                    applicationDidFinshLaunchingFrom(sut);
                });
            });
            describe(@"Window", ^{
                __block UIWindow* mockWindow;
                beforeEach(^{
                    mockWindow = [UIWindow nullMock];
                    
                });
                afterEach(^{
                    mockWindow = nil;
                });
                it(@"should not be nil", ^{
                    applicationDidFinshLaunchingFrom(sut);
                    
                    [[sut.window shouldNot] beNil];
                });
                it(@"frame should be called", ^{
                    [sut stub:@selector(window) andReturn:mockWindow];
                    
                    [[mockWindow should] receive:@selector(setFrame:) withArguments:any()];
                    
                    applicationDidFinshLaunchingFrom(sut);
                });
                it(@"makeKeyAndVisible should be called", ^{
                    [sut stub:@selector(window) andReturn:mockWindow];
                    
                    [[mockWindow should] receive:@selector(makeKeyAndVisible)];

                    applicationDidFinshLaunchingFrom(sut);
                });
            });
            
            
            context(@"have a saved User", ^{
                __block QBUUser *user;
                
                __block LocalStorageService *mockLocalStorageService;
                
                beforeEach(^{
                    mockLocalStorageService = [LocalStorageService nullMock];
                    [sut stub:@selector(localStorageService) andReturn:mockLocalStorageService];
                    
                    user = [QBUUser new];
                    [mockLocalStorageService stub:@selector(savedUser) andReturn:user];
                });
                afterEach(^{
                    mockLocalStorageService = nil;
                    
                    user = nil;
                });
                it(@"should have a LocalStorageService", ^{
                    RGSAppDelegate *appDelegate = [RGSAppDelegate new];
                    
                    applicationDidFinshLaunchingFrom(appDelegate);
                    
                    [[appDelegate.localStorageService shouldNot] beNil];
                });
                context(@"user is login", ^{
                    __block NSUserDefaults *userDefaults;
                    
                    beforeEach(^{
                        
                        user.login = @"bar";
                        user.password = @"bar";
                        
                        userDefaults = [NSUserDefaults standardUserDefaults];
                        
                        [userDefaults stub:@selector(objectForKey:) andReturn:[NSNumber numberWithBool:YES] withArguments:@"isAutoLogin"];
                    });
                    it(@"should have userDefaults", ^{
                        RGSAppDelegate *appDelegate = [RGSAppDelegate new];
                        
                        applicationDidFinshLaunchingFrom(appDelegate);
                        
                        [[appDelegate.userDefaults shouldNot] beNil];
                    });
                    
                    it(@"window.rootViewController should be saved screen", ^{
//                        UIWindow *testWindow = [[UIWindow new] init];
//                        testWindow.frame = CGRectZero;
//                        [sut stub:@selector(window) andReturn:testWindow];
//
//                        
//                        [userDefaults setObject:NSStringFromClass([UITableViewController class]) forKey:@"lastVisibleViewController"];
                        
//                        applicationDidFinshLaunchingFrom(sut);
//                    
//                        [[sut.window.rootViewController should] beKindOfClass:[UITableViewController class]];
                        
                    });
                
                });
            });
            context(@"doesn't have saved user", ^{
                __block LocalStorageService *mockLocalStorageService;
                
                beforeEach(^{
                    mockLocalStorageService = [LocalStorageService nullMock];
                    [sut stub:@selector(localStorageService) andReturn:mockLocalStorageService];
                    
                    
                    [mockLocalStorageService stub:@selector(savedUser) andReturn:nil];
                });
                afterEach(^{
                    mockLocalStorageService = nil;
                });

                describe(@"loginViewController", ^{
                    it(@"should be not be nil", ^{
                        applicationDidFinshLaunchingFrom(sut);
                        
                        [[sut.loginViewController shouldNot] beNil];
                    });
                    
                    it(@"delegate should be UserLoginDelegate", ^{
                        applicationDidFinshLaunchingFrom(sut);
                        
                        NSObject *lvcD = (NSObject *)sut.loginViewController.delegate;
                        
                        [[lvcD should] beKindOfClass:[userMangementService class]];
                    });
                });
                it(@"Window's rootViewController should be loginViewController", ^{
                    applicationDidFinshLaunchingFrom(sut);
                    
                    [[sut.window.rootViewController should] beKindOfClass:[RGSLoginViewController class]];
                });
            });
            it(@"should return YES", ^{
                [[theValue(applicationDidFinshLaunchingFrom(sut)) should] equal:theValue(YES)];
            });
        });
    });

});

SPEC_END
