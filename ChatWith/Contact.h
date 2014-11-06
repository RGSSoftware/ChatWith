//
//  Contact.h
//  ChatWith
//
//  Created by PC on 10/31/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ManagedUser;

@interface Contact : NSManagedObject

@property (nonatomic, retain) ManagedUser *source;
@property (nonatomic, retain) ManagedUser *friend;

@end
