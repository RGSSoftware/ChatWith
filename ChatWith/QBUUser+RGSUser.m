//
//  QBUUser+RGSUser.m
//  ChatWith
//
//  Created by PC on 2/4/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "QBUUser+RGSUser.h"
#import "RGSUser.h"

@implementation QBUUser (RGSUser)

-(RGSUser *)rgsUser{
    RGSUser *managedUser = [RGSUser MR_createEntity];
    managedUser.externalUserID = [NSNumber numberWithUnsignedInteger:self.externalUserID];
    managedUser.blobID = [NSNumber numberWithInteger:self.blobID];
    managedUser.facebookID = self.facebookID;
    managedUser.twitterID = self.twitterID;
    managedUser.fullName = self.fullName;
    managedUser.email = self.email;
    managedUser.login = self.login;
    managedUser.phone = self.phone;
    managedUser.website = self.website;
    managedUser.password = self.password;
    managedUser.oldPassword = self.oldPassword;
    managedUser.lastRequestAt = self.lastRequestAt;
    
    return managedUser;
}

@end
