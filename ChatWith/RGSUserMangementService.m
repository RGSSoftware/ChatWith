//
//  RGSUserLoginDelegate.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSUserMangementService.h"
#import "ManagedUser.h"
#import "LocalStorageService.h"

@interface RGSUserMangementService ()
@property (nonatomic, strong)void(^userNameTakenBlock)(BOOL taken);
@property (nonatomic, strong)void(^registerSuccessBlock)(BOOL taken);
@property (nonatomic, strong)void(^loginSuccessBlock)(BOOL taken);
@end


@implementation RGSUserMangementService

-(void)isUsernameTaken:(NSString *)username successBlock:(void (^)(BOOL isTaken))results{
    [QBRequest userWithLogin:username successBlock:^(QBResponse *response, QBUUser *user) {
        results(YES);
    } errorBlock:^(QBResponse *response) {
        if(response.status == QBResponseStatusCodeNotFound) results(NO);
    }];
}


-(void)registerUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))results{
    QBUUser *user = [QBUUser user];
    user.login = username;
    user.password = password;
    [self.qBSUsers signUp:user delegate:self];
    [QBRequest signUp:user
         successBlock:^(QBResponse *response, QBUUser *user) {
             [[LocalStorageService shared] creteCurrentUserWithQBUser:user successBlock:^(BOOL success, NSError *error) {
                 if(success) results(YES);
             }];
         } errorBlock:^(QBResponse *response) {
             results(NO);
         }];
}

-(void)loginUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))success{
    self.loginSuccessBlock = success;
    if([[LocalStorageService shared] savedUser]){
        //If user is trying to login, but there Credentials are saved
        if([[[LocalStorageService shared] savedUser].login isEqualToString:username]){
            //login saved user
            [self.qBSUsers logInWithUserLogin:username password:password delegate:self];
        } else {
            //when user is not a saved user
            
            //delete saved user
            [[[LocalStorageService shared] savedUser] MR_deleteEntity];
            //save new user with {username and password}
            [[LocalStorageService shared] createCurrentUserWithusername:username password:password successBlock:^(BOOL success, NSError *error) {
                //login new user
                if(success) [self.qBSUsers logInWithUserLogin:username password:password delegate:self];
            }];
        }
    } else {
        //save new user with {username and password}
        [[LocalStorageService shared] createCurrentUserWithusername:username password:password successBlock:^(BOOL success, NSError *error) {
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
            
            [[LocalStorageService shared] creteCurrentUserWithQBUser:((QBUUserResult *)result).user successBlock:^(BOOL success, NSError *error) {
                if(success) self.registerSuccessBlock(YES);
            }];
        }
    } else if ([[NSString stringWithFormat:@"%@", [result class]]
                isEqualToString:[NSString stringWithFormat:@"%@", [QBUUserLogInResult class]]]){
        if(!result.success && result.status == 401) self.loginSuccessBlock(NO);
        else if (result.success && result.status == 202) self.loginSuccessBlock(YES);
    }
}

-(Class)qBSUsers{
    if (_qBSUsers == nil)
    {
        _qBSUsers = [QBUsers class];
    }
    return _qBSUsers;
}
@end
