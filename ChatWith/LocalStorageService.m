//
//  LocalStorageService.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "LocalStorageService.h"
#import "ManagedUser.h"

@implementation LocalStorageService{
    NSMutableDictionary *messagesHistory;
    
}

static LocalStorageService *_instance= nil;
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
-(ManagedUser *)savedUser{
    return [[ManagedUser MR_findByAttribute:@"currentUser" withValue:@YES] firstObject];
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

@end
