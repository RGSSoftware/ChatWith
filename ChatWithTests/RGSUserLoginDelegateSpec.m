//
//  RGSUserLoginDelegateSpec.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright 2014 Randel Smith. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RGSUserLoginDelegate.h"
#import "RGSLoginViewController.h"


SPEC_BEGIN(RGSUserLoginDelegateSpec)

describe(@"RGSUserLoginDelegate", ^{
    __block RGSUserLoginDelegate *sut;
    
    beforeEach(^{
        sut = [RGSUserLoginDelegate new];
    });
    afterEach(^{
        sut = nil;
    });
    it(@"should conform to LoginViewControllerDelegate", ^{
        [[sut should] conformToProtocol:@protocol(LoginViewControllerDelegate)];
    });
});

SPEC_END
