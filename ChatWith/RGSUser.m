//
//  RGSManagedUser.m
//  ChatWith
//
//  Created by PC on 11/12/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSUser.h"
#import "RGSChat.h"
#import "RGSContact.h"
#import "RGSMessage.h"


@implementation RGSUser

@dynamic blobID;
@dynamic createdAt;
@dynamic currentUser;
@dynamic customData;
@dynamic email;
@dynamic entityID;
@dynamic externalUserID;
@dynamic facebookID;
@dynamic fullName;
@dynamic imageData;
@dynamic lastRequestAt;
@dynamic login;
@dynamic oldPassword;
@dynamic password;
@dynamic phone;
@dynamic twitterID;
@dynamic updatedAt;
@dynamic website;
@dynamic befriend;
@dynamic chats;
@dynamic chatsEX;
@dynamic contacts;
@dynamic partofChats;
@dynamic sentMessages;
@dynamic receiveMessages;

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
