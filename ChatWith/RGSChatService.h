//
//  RGSChatService.h
//  ChatWith
//
//  Created by PC on 10/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RGSManagedUser;

@interface RGSChatService : NSObject

+ (instancetype)shared;

-(void)loginUser:(QBUUser *)user successBlock:(void (^)(BOOL success))success;

-(void)allConversationsFromUser:(RGSManagedUser *)user startingAt:(NSDate *)startDate successBlock:(void(^)(BOOL success, NSArray *conversations))successBlock;
@end
