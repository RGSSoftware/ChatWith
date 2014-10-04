//
//  RGSUserLoginDelegate.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "userMangementService.h"
#import "ManagedUser.h"
#import "LocalStorageService.h"

@interface userMangementService ()
@property (nonatomic, strong)void(^userNameTakenBlock)(BOOL taken);
@property (nonatomic, strong)void(^registerSuccessBlock)(BOOL taken);
@property (nonatomic, strong)void(^loginSuccessBlock)(BOOL taken);
@end


@implementation userMangementService

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

-(void)loginUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))success{
    self.loginSuccessBlock = success;
    if([[LocalStorageService shared] savedUser]){
        if([[[LocalStorageService shared] savedUser].login isEqualToString:username]){
            //login saved user
            [self.qBSUsers logInWithUserLogin:username password:password delegate:self];
        } else {
            //delete saved user
            [[[LocalStorageService shared] savedUser] MR_deleteEntity];
            //save new user with {username and password}
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                ManagedUser *managedUser = [ManagedUser MR_createEntity];
                managedUser.login = username;
                managedUser.password = password;
                managedUser.currentUser = [NSNumber numberWithBool:YES];
            } completion:^(BOOL success, NSError *error) {
                //login new user
                if(success) [self.qBSUsers logInWithUserLogin:username password:password delegate:self];
            }];
        }
    } else {
        //save new user with {username and password}
        [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
            ManagedUser *managedUser = [ManagedUser MR_createEntity];
            managedUser.login = username;
            managedUser.password = password;
            managedUser.currentUser = [NSNumber numberWithBool:YES];
        } completion:^(BOOL success, NSError *error) {
            //login new user
            if(success) [self.qBSUsers logInWithUserLogin:username password:password delegate:self];
        }];
        
    }
    
    
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
    } else if ([[NSString stringWithFormat:@"%@", [result class]]
                isEqualToString:[NSString stringWithFormat:@"%@", [QBUUserLogInResult class]]]){
        if(!result.success && result.status == 401) self.loginSuccessBlock(NO);
        else if (result.success && result.status == 202) self.loginSuccessBlock(YES);
    }
}

-(void)saveQBUserToCoreData:(QBUUser *)qBUser completion:(void (^)(BOOL success))completion{
    
    
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
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
        //    managedUser.customData = qBUser.customData;
        
        managedUser.currentUser = [NSNumber numberWithBool:YES];
    }   completion:^(BOOL success, NSError *error) {
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
