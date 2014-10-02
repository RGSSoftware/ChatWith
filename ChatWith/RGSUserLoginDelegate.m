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
            QBUUserResult *userResult = (QBUUserResult *)result;
            
//            ManagedUser *managedUser = [ManagedUser ]
//            userResult.user.
            
            self.registerSuccessBlock(YES);
            
            //save user to coreData
        }
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
