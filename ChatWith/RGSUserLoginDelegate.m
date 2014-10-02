//
//  RGSUserLoginDelegate.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSUserLoginDelegate.h"
#import "ManagedUser.h"

@interface RGSUserLoginDelegate ()
@property (nonatomic, strong)void(^userNameTakenBlock)(BOOL taken);
@property (nonatomic, strong)void(^registerSuccessBlock)(BOOL taken);
@end


@implementation RGSUserLoginDelegate

-(void)isUsernameTaken:(NSString *)username successBlock:(void (^)(BOOL isTaken))results{
    self.userNameTakenBlock = results;
    
    [self.qBSUsers userWithLogin:username delegate:self];
}

-(void)registerUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))success{
    self.registerSuccessBlock = success;
    
    
    QBUUser *user = [QBUUser user];
    user.login = username;
    user.password = password;
    [self.qBSUsers signUp:user delegate:self];
}

-(void)completedWithResult:(Result *)result{
    
    if([[NSString stringWithFormat:@"%@", [result class]]
        isEqualToString:[NSString stringWithFormat:@"%@", [QBUUserResult class]]]){
        if(!result.success && result.status == 404) {self.userNameTakenBlock(NO);}
        else if (result.success && result.status == 200) {self.userNameTakenBlock(YES);}
        else if (result.success && result.status == 201) {
            
            [self saveQBUserToCoreData:((QBUUserResult *)result).user completion:^(BOOL success) {
                if(success) self.registerSuccessBlock(YES);
            }];
        }
    }
}

-(void)saveQBUserToCoreData:(QBUUser *)qBUser completion:(void (^)(BOOL success))completion{
    ManagedUser *managedUser = [ManagedUser MR_createEntity];
    managedUser.externalUserID = [NSNumber numberWithUnsignedInteger:qBUser.externalUserID];
    managedUser.blobID = [NSNumber numberWithInteger:qBUser.blobID];
    managedUser.facebookID = qBUser.facebookID;
    managedUser.twitterID = qBUser.twitterID;
    managedUser.fullName = qBUser.fullName;
    managedUser.email = qBUser.email;
    managedUser.login = qBUser.login;
    managedUser.phone = qBUser.phone;
    managedUser.website = qBUser.website;
    managedUser.password = qBUser.password;
    managedUser.oldPassword = qBUser.oldPassword;
    managedUser.lastRequestAt = qBUser.lastRequestAt;
    managedUser.customData = qBUser.customData;
    
    [MagicalRecord saveWithBlock:nil completion:^(BOOL success, NSError *error) {
        if(success) completion(success);
    }];
}

-(Class)qBSUsers{
    if (_qBSUsers == nil)
    {
        _qBSUsers = [QBUsers class];
    }
    return _qBSUsers;
}
@end
