//
//  RGSChat.h
//  ChatWith
//
//  Created by PC on 11/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSManagedUser, RGSMessage;

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
@property (nonatomic, retain) RGSManagedUser *receiver;
@property (nonatomic, retain) RGSManagedUser *sender;
@property (nonatomic, retain) NSSet *participants;
@end

@interface RGSChat (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(RGSMessage *)value;
- (void)removeMessagesObject:(RGSMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addParticipantsObject:(RGSManagedUser *)value;
- (void)removeParticipantsObject:(RGSManagedUser *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

@end
