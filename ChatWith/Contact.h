//
//  Contact.h
//  ChatWith
//
//  Created by PC on 10/31/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSManagedUser;

@interface Contact : NSManagedObject

@property (nonatomic, retain) RGSManagedUser *source;
@property (nonatomic, retain) RGSManagedUser *friend;

@end
