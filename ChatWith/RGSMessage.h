//
//  RGSMessage.h
//  ChatWith
//
//  Created by PC on 2/21/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSChat, RGSImage, RGSUser;

@interface RGSMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * sendStatus;
@property (nonatomic, retain) NSNumber * isUnread;
@property (nonatomic, retain) RGSChat *chat;
@property (nonatomic, retain) RGSImage *image;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) RGSUser *receiver;
@property (nonatomic, retain) RGSUser *sender;
@end

@interface RGSMessage (CoreDataGeneratedAccessors)

- (void)addImagesObject:(RGSImage *)value;
- (void)removeImagesObject:(RGSImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
