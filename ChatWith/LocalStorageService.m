//
//  LocalStorageService.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "LocalStorageService.h"
#import "RGSManagedUser.h"

#import "ApplicationSession.h"

@implementation LocalStorageService{
    NSMutableDictionary *messagesHistory;
    
}

static LocalStorageService *_instance = nil;
static dispatch_once_t once_token = 0;

+ (instancetype)shared
{
	dispatch_once(&once_token, ^{
          if (_instance == nil) {
		_instance = [[LocalStorageService alloc] init];
          }
	});
	
	return _instance;
}
+(void)setSharedInstance:(LocalStorageService *)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _instance = instance;
}


- (id)init
{
    self = [super init];
    if(self){
        messagesHistory = [NSMutableDictionary dictionary];
    }
    return self;
}
-(RGSManagedUser *)savedUser{
    return [RGSManagedUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
}
-(QBUUser *)savedUserAsQBUUser{
    RGSManagedUser *currentUser = [RGSManagedUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
    
    QBUUser *qbUser = [QBUUser user];
    qbUser.externalUserID = [currentUser.externalUserID unsignedIntegerValue];
    qbUser.blobID = [currentUser.blobID integerValue];
    qbUser.facebookID = currentUser.facebookID;
    qbUser.twitterID = currentUser.twitterID;
    qbUser.fullName = currentUser.fullName;
    qbUser.email = currentUser.email;
    qbUser.login = currentUser.login;
    qbUser.phone = currentUser.phone;
    qbUser.website = currentUser.website;
    qbUser.password = currentUser.password;
    qbUser.oldPassword = currentUser.oldPassword;
    qbUser.lastRequestAt = currentUser.lastRequestAt;
    qbUser.ID = [currentUser.entityID integerValue];
        
    return qbUser;
    
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
        RGSManagedUser *managedUser = [RGSManagedUser MR_createEntity];
        managedUser.login = username;
        managedUser.password = password;
        managedUser.currentUser = [NSNumber numberWithBool:YES];
    } completion:^(BOOL success, NSError *error) {
        successBlock(success, error);
    }];
}
-(void)creteCurrentUserWithQBUser:(QBUUser *)qBUser successBlock:(void (^)(BOOL, NSError *))successBlock{
    
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
        RGSManagedUser *managedUser = [RGSManagedUser MR_createEntity];
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
