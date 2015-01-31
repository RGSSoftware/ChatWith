//
//  Contact.h
//  ChatWith
//
//  Created by PC on 10/31/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSUser;

@interface RGSContact : NSManagedObject

@property (nonatomic, retain) RGSUser *source;
@property (nonatomic, retain) RGSUser *friend;

@end
