//
//  LocalStorageService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface LocalStorageService : NSObject

//@property (nonatomic, strong) QBUUser *currentUser;

+ (instancetype)shared;
//- (void)saveMessageToHistory:(QBChatMessage *)message withUserID:(NSUInteger)userID;
//- (NSMutableArray *)messageHistoryWithUserID:(NSUInteger)userID;
+ (void)setSharedInstance:(id)sharedInstance;
-(void)saveCurrentUser:(UserModel *)user;
-(QBUUser *)savedUser;

@end
