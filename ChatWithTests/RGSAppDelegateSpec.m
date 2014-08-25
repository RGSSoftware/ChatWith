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
            it(@"Window's frame should be called", ^{
                UIWindow *mockWindow = [UIWindow nullMock];
                [[mockWindow should] receive:@selector(setFrame:) withArguments:any()];
                
                [sut stub:@selector(window) andReturn:mockWindow];
                
                applicationDidFinshLaunchingFrom(sut);
            });
            it(@"Window's should makeKeyAndVisible", ^{
                UIWindow *mockWindow = [UIWindow nullMock];
                [[mockWindow should] receive:@selector(makeKeyAndVisible)];
                
                [sut stub:@selector(window) andReturn:mockWindow];
                
                applicationDidFinshLaunchingFrom(sut);
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
        });
    });

});

SPEC_END
