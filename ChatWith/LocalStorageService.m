//
//  LocalStorageService.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "LocalStorageService.h"
#import "ManagedUser.h"

#import "ApplicationSession.h"

@implementation LocalStorageService{
    NSMutableDictionary *messagesHistory;
    
}

+ (instancetype)shared{
    static id shared_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_ = [[self alloc] init];
    });
    
    return shared_;
}

-(ManagedUser *)savedUser{
    return [ManagedUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
}

//- (void)saveMessageToHistory:(QBChatMessage *)message withUserID:(NSUInteger)userID
//{
//    NSMutableArray *messages = [messagesHistory objectForKey:@(userID)];
//    if(messages == nil){
//        messages = [NSMutableArray array];
//        [messagesHistory setObject:messages forKey:@(userID)];
//    }
//    [messages addObject:message];
//}
//
//- (NSMutableArray *)messageHistoryWithUserID:(NSUInteger)userID
//{
//    NSMutableArray *messages = [messagesHistory objectForKey:@(userID)];
//    if(messages == nil){
//        messages = [NSMutableArray array];
//        [messagesHistory setObject:messages forKey:@(userID)];
//    }
//    return messages;
//}

-(void)createCurrentUserWithusername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL, NSError *))successBlock{
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        ManagedUser *managedUser = [ManagedUser MR_createEntity];
        managedUser.login = username;
        managedUser.password = password;
        managedUser.currentUser = [NSNumber numberWithBool:YES];
    } completion:^(BOOL success, NSError *error) {
        successBlock(success, error);
    }];
}
-(void)creteCurrentUserWithQBUser:(QBUUser *)qBUser successBlock:(void (^)(BOOL, NSError *))successBlock{
    
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
        
        managedUser.currentUser = [NSNumber numberWithBool:YES];
    }   completion:^(BOOL success, NSError *error) {
        successBlock(success, error);
    }];
}
-(ApplicationSession *)applicationSession{
    return [ApplicationSession MR_findFirst];
}

-(void)crateApplicationSessionWithQBASession:(QBASession *)session successBlock:(void (^)(BOOL, NSError *))successBlock{
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        ApplicationSession *applicationSession = [ApplicationSession MR_createEntity];
        applicationSession.applicationID = [NSNumber numberWithUnsignedInteger:session.applicationID];
        applicationSession.userID = [NSNumber numberWithUnsignedInteger:session.userID];
        applicationSession.deviceID = [NSNumber numberWithUnsignedInteger:session.deviceID];
        applicationSession.timstamp = [NSNumber numberWithUnsignedInteger:session.timestamp];
        applicationSession.nonce = [NSNumber numberWithInteger:session.nonce];
        applicationSession.token = session.token;
        
    }   completion:^(BOOL success, NSError *error) {
        successBlock(success, error);
    }];

}

@end
