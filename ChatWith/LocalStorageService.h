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
@class ApplicationSession;
@class Converstation;

@interface LocalStorageService : NSObject

@property (nonatomic, strong)ApplicationSession *applicationSession;
@property (nonatomic, strong)Converstation *lastestConverstation;

+ (instancetype)shared;
//+ (void)setSharedInstance:(id)sharedInstance;


-(ManagedUser *)savedUser;

-(QBUUser *)savedUserAsQBUUser;

-(void)crateApplicationSessionWithQBASession:(QBASession *)session successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)createCurrentUserWithusername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)creteCurrentUserWithQBUser:(QBUUser *)qBUser successBlock:(void (^)(BOOL success, NSError *error))successBlock;

-(void)saveConversations:(NSArray *)conversations;

@end
