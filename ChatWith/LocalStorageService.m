//
//  LocalStorageService.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "LocalStorageService.h"

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
-(QBUUser *)savedUser{
//    NSArray *users = [UserModel MR_findByAttribute:@"uuuuserLogin" withValue:@YES];
//    
//    return [users firstObject];
    
//    return [currentUsers firstObject];
    return nil;
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


@end
