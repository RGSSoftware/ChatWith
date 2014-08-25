//
//  RGSAppDelegateSpec.m
//  ChatWith
//
//  Created by PC on 8/25/14.
//  Copyright 2014 Randel Smith. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RGSAppDelegate.h"

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
                    [sut stub:@selector(window) andReturn:mockWindow];
                });
                afterEach(^{
                    mockWindow = nil;
                });
                it(@"should not be nil", ^{
                    applicationDidFinshLaunchingFrom(sut);
                    
                    [[sut.window shouldNot] beNil];
                });
                it(@"frame should be called", ^{
                    [[mockWindow should] receive:@selector(setFrame:) withArguments:any()];
                    
                    applicationDidFinshLaunchingFrom(sut);
                });
                it(@"makeKeyAndVisible should be called", ^{
                    [[mockWindow should] receive:@selector(makeKeyAndVisible)];

                    applicationDidFinshLaunchingFrom(sut);
                });
            });
            
            
            context(@"have a saved User", ^{
                context(@"user is login", ^{
                });
            });
            context(@"doesn't have saved user", ^{
                describe(@"loginViewController", ^{
                    it(@"delegate should be self", ^{
                        
                    });
                });
                it(@"Window's rootViewController should be loginViewController", ^{
                });
            });
            it(@"should return YES", ^{
                [[theValue(applicationDidFinshLaunchingFrom(sut)) should] equal:theValue(YES)];
            });
        });
    });

});

SPEC_END
