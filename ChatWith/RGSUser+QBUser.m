//
//  RGSUser+QBUser.m
//  ChatWith
//
//  Created by PC on 1/31/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSUser+QBUser.h"

@implementation RGSUser (QBUser)
-(QBUUser *)qbUser{
    QBUUser *qbUser = [QBUUser user];
    qbUser.externalUserID = [self.externalUserID unsignedIntegerValue];
    qbUser.blobID = [self.blobID integerValue];
    qbUser.facebookID = self.facebookID;
    qbUser.twitterID = self.twitterID;
    qbUser.fullName = self.fullName;
    qbUser.email = self.email;
    qbUser.login = self.login;
    qbUser.phone = self.phone;
    qbUser.website = self.website;
    qbUser.password = self.password;
    qbUser.oldPassword = self.oldPassword;
    qbUser.lastRequestAt = self.lastRequestAt;
    qbUser.ID = [self.entityID integerValue];
    
    return qbUser;
}
@end
