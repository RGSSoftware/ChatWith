//
//  RGSChat.h
//  ChatWith
//
//  Created by PC on 11/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSUser, RGSMessage;

@interface RGSChat : NSManagedObject

@property (nonatomic, retain) NSString * entityID;
@property (nonatomic, retain) NSString * lastMessagaeText;
@property (nonatomic, retain) NSDate * lastMessageDate;
@property (nonatomic, retain) NSNumber * lastMessageID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * roomJID;
@property (nonatomic, retain) NSNumber * unreadMessagesCount;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) RGSUser *receiver;
@property (nonatomic, retain) RGSUser *sender;
@property (nonatomic, retain) NSSet *participants;
@end

@interface RGSChat (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(RGSMessage *)value;
- (void)removeMessagesObject:(RGSMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addParticipantsObject:(RGSUser *)value;
- (void)removeParticipantsObject:(RGSUser *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

+(id)RGS_createEntity;

@end
