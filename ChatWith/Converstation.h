//
//  Converstation.h
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ManagedUser;

@interface Converstation : NSManagedObject

@property (nonatomic, retain) NSString * entityID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * roomJID;
@property (nonatomic, retain) NSString * lastMessagaeText;
@property (nonatomic, retain) NSDate * lastMessageDate;
@property (nonatomic, retain) NSNumber * lastMessageID;
@property (nonatomic, retain) NSNumber * unreadMessagesCount;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSSet *occupants;
@end

@interface Converstation (CoreDataGeneratedAccessors)

- (void)addOccupantsObject:(ManagedUser *)value;
- (void)removeOccupantsObject:(ManagedUser *)value;
- (void)addOccupants:(NSSet *)values;
- (void)removeOccupants:(NSSet *)values;

@end
