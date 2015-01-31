//
//  QBASession+RGSApplicationSession.m
//  ChatWith
//
//  Created by PC on 1/31/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "QBASession+RGSApplicationSession.h"
#import "RGSApplicationSession.h"

@implementation QBASession (RGSApplicationSession)

-(RGSApplicationSession *)rgsApplicationSession{
    RGSApplicationSession *applicationSession = [RGSApplicationSession MR_createEntity];
    applicationSession.applicationID = [NSNumber numberWithUnsignedInteger:self.applicationID];
    applicationSession.userID = [NSNumber numberWithUnsignedInteger:self.userID];
    applicationSession.deviceID = [NSNumber numberWithUnsignedInteger:self.deviceID];
    applicationSession.timstamp = [NSNumber numberWithUnsignedInteger:self.timestamp];
    applicationSession.nonce = [NSNumber numberWithInteger:self.nonce];
    applicationSession.token = self.token;
    
    return applicationSession;
}


@end
