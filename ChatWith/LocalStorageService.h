//
//  LocalStorageService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class RGSManagedUser;
@class RGSApplicationSession;
@class RGSChat;

@interface LocalStorageService : NSObject

@property (nonatomic, strong)RGSApplicationSession *applicationSession;
@property (nonatomic, strong)RGSChat *lastestConverstation;

+ (instancetype)shared;
//+ (void)setSharedInstance:(id)sharedInstance;


-(RGSManagedUser *)savedUser;

-(QBUUser *)savedUserAsQBUUser;

-(void)crateApplicationSessionWithQBASession:(QBASession *)session successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)createCurrentUserWithusername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)creteCurrentUserWithQBUser:(QBUUser *)qBUser successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)saveConversations:(NSArray *)conversations;

@end
