//
//  RGSApplicationSessionManagementService.m
//  ChatWith
//
//  Created by PC on 10/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSApplicationSessionManagementService.h"

@interface RGSApplicationSessionManagementService ()
@property (nonatomic, strong)void(^sessionCreationBlock)(BOOL success);

@end

@implementation RGSApplicationSessionManagementService

-(void)createSessionWithCompletion:(void (^)(BOOL))completion{
    self.sessionCreationBlock = completion;
    
    [QBAuth createSessionWithDelegate:self];
}


-(void)completedWithResult:(Result *)result{
    if([[NSString stringWithFormat:@"%@", [result class]]
        isEqualToString:[NSString stringWithFormat:@"%@", [QBAAuthSessionCreationResult class]]] ){
        if(!result.success) self.sessionCreationBlock(NO);
        else if (result.success && result.status == 201) {self.sessionCreationBlock(YES);}
    } else self.sessionCreationBlock(NO);
}

-(NSUInteger)applicationID{
    return [QBSettings applicationID];
}

-(void)setApplicationID:(NSUInteger)applicationID{
    [QBSettings setApplicationID:applicationID];
}

-(NSString *)authorizationKey{
    return [QBSettings authorizationKey];
}

-(void)setAuthorizationKey:(NSString *)authorizationKey{
    [QBSettings setAuthorizationKey:authorizationKey];
}

-(NSString *)authorizationSecret{
    return [QBSettings authorizationSecret];
}

-(void)setAuthorizationSecret:(NSString *)authorizationSecret{
    [QBSettings setAuthorizationSecret:authorizationSecret];
}


@end
