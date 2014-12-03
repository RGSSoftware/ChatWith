//
//  RGSMessage.h
//  ChatWith
//
//  Created by PC on 12/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSChat, RGSImage, RGSManagedUser;

@interface RGSMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) RGSChat *chat;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) RGSManagedUser *receiver;
@property (nonatomic, retain) RGSManagedUser *sender;
@property (nonatomic, retain) RGSImage *image;
@end

@interface RGSMessage (CoreDataGeneratedAccessors)

- (void)addImagesObject:(RGSImage *)value;
- (void)removeImagesObject:(RGSImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
