//
//  ManagedUser.m
//  ChatWith
//
//  Created by PC on 10/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "ManagedUser.h"


@implementation ManagedUser

@dynamic externalUserID;
@dynamic blobID;
@dynamic facebookID;
@dynamic twitterID;
@dynamic fullName;
@dynamic email;
@dynamic login;
@dynamic phone;
@dynamic website;
@dynamic password;
@dynamic oldPassword;
@dynamic lastRequestAt;
@dynamic customData;
@dynamic currentUser;
@dynamic entityID;
@dynamic createdAt;
@dynamic updatedAt;

-(BOOL)isSignIn{
    NSString *login;
    NSString *password;
    
    [self willAccessValueForKey:@"login"];
    login = [self login];
    [self didAccessValueForKey:@"login"];
    
    [self willAccessValueForKey:@"password"];
    password = [self password];
    [self didAccessValueForKey:@"password"];
    
    if (login && password && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"] boolValue]) {
        return YES;
    }
    return NO;
}

@end
