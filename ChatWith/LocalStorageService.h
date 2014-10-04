//
//  LocalStorageService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class ManagedUser;

@interface LocalStorageService : NSObject

//@property (nonatomic, strong) QBUUser *currentUser;

+ (instancetype)shared;
//- (void)saveMessageToHistory:(QBChatMessage *)message withUserID:(NSUInteger)userID;
//- (NSMutableArray *)messageHistoryWithUserID:(NSUInteger)userID;
+ (void)setSharedInstance:(id)sharedInstance;
-(void)saveCurrentUser:(UserModel *)user;
-(ManagedUser *)savedUser;

-(void)createCurrentUserWithusername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)creteCurrentUserWithQBUser:(QBUUser *)qBUser successBlock:(void (^)(BOOL success, NSError *error))successBlock;

@end
