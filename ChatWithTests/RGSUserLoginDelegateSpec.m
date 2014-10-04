//
//  RGSUserLoginDelegateSpec.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright 2014 Randel Smith. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RGSUserMangementService.h"
#import "RGSLoginViewController.h"

SPEC_BEGIN(RGSUserLoginDelegateSpec)

describe(@"RGSUserLoginDelegate", ^{
    __block RGSUserMangementService *sut;
    
    beforeEach(^{
        sut = [RGSUserMangementService new];
    });
    afterEach(^{
        sut = nil;
    });
    it(@"should conform to LoginViewControllerDelegate", ^{
        [[sut should] conformToProtocol:@protocol(LoginViewControllerDelegate)];
    });
    context(@"username is bar", ^{
        it(@"should return YES", ^{
            [[theValue([sut loginViewController:nil isUsernameTaken:@"bar"]) should] equal:theValue(YES)];
        });
    });
    context(@"username is foo", ^{
        it(@"should return No", ^{
            [[theValue([sut loginViewController:nil isUsernameTaken:@"foo"]) should] equal:theValue(NO)];
        });
    });
    
    context(@"username is bob", ^{
        __block Class mockQBUsers;
        beforeEach(^{
            mockQBUsers = [QBUsers nullMock];
        });
        afterEach(^{
            mockQBUsers = nil;
        });
        it(@"should return Yes", ^{
            //given
            [[mockQBUsers should] receive:@selector(userWithLogin:delegate:) withArguments:@"bob", sut];
            
            //then
            [[theValue([sut loginViewController:nil isUsernameTaken:@"bar"]) should] equal:theValue(YES)];
            
            
        });
    });
});

SPEC_END
