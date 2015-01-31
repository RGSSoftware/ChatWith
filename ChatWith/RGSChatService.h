//
//  RGSChatService.h
//  ChatWith
//
//  Created by PC on 10/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RGSUser;
@class RGSMessage;

@interface RGSChatService : NSObject
@property(readonly)BOOL canReach;

+ (instancetype)shared;

-(void)loginUser:(QBUUser *)user successBlock:(void (^)(BOOL success))success;

-(void)allConversationsFromUser:(RGSUser *)user startingAt:(NSDate *)startDate successBlock:(void(^)(BOOL success, NSArray *conversations))successBlock;

-(void)sendMessage:(RGSMessage *)message;


@end
