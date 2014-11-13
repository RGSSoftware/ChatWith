//
//  RGSMessage.h
//  ChatWith
//
//  Created by PC on 11/12/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSChat, RGSManagedUser;

@interface RGSMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) RGSChat *chat;
@property (nonatomic, retain) RGSManagedUser *sender;
@property (nonatomic, retain) RGSManagedUser *receiver;

@end
