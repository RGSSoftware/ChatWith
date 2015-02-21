//
//  RGSChat.h
//  ChatWith
//
//  Created by PC on 2/21/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSMessage, RGSUser;

@interface RGSChat : NSManagedObject

@property (nonatomic, retain) NSString * entityID;
@property (nonatomic, retain) NSString * lastMessagaeText;
@property (nonatomic, retain) NSDate * lastMessageDate;
@property (nonatomic, retain) NSNumber * lastMessageID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * roomJID;
@property (nonatomic, retain) NSNumber * unreadMessagesCount;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) id lastestMessage;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NSSet *participants;
@property (nonatomic, retain) RGSUser *receiver;
@property (nonatomic, retain) RGSUser *sender;
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

@end
