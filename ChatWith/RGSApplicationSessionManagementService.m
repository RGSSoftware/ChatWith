//
//  RGSApplicationSessionManagementService.m
//  ChatWith
//
//  Created by PC on 10/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSApplicationSessionManagementService.h"
#import "LocalStorageService.h"
#import "ApplicationSession.h"

@implementation RGSApplicationSessionManagementService

-(void)createSessionWithCompletion:(void (^)(BOOL))completion{
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [[LocalStorageService shared].applicationSession MR_deleteEntity];
        [[LocalStorageService shared] crateApplicationSessionWithQBASession:session successBlock:^(BOOL success, NSError *error) {
            completion(success);
        }];
    } errorBlock:^(QBResponse *response) {
        completion(NO);
    }];
}

-(NSUInteger)applicationID{
    
    return [QBApplication sharedApplication].applicationId;
}

-(void)setApplicationID:(NSUInteger)applicationID{
    [QBApplication sharedApplication].applicationId = applicationID;
}


-(void)setAuthorizationKey:(NSString *)authorizationKey{
    [QBConnection registerServiceKey:authorizationKey];
}

-(void)setAuthorizationSecret:(NSString *)authorizationSecret{
    [QBConnection registerServiceSecret:authorizationSecret];
}

-(NSString *)accountKey{
   return [QBSettings accountKey];
}

-(void)setAccountKey:(NSString *)accountKey{
    [QBSettings setAccountKey:accountKey];
}


@end
