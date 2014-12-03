//
//  RGSImage.h
//  ChatWith
//
//  Created by PC on 12/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSMessage;

@interface RGSImage : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) RGSMessage *message;
@property (nonatomic, retain) RGSMessage *messageImage;

@end
