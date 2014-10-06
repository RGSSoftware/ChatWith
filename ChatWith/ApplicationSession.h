//
//  ApplicationSession.h
//  ChatWith
//
//  Created by PC on 10/5/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApplicationSession : NSManagedObject

@property (nonatomic, retain) NSNumber * entityID;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * applicationID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * deviceID;
@property (nonatomic, retain) NSNumber * timstamp;
@property (nonatomic, retain) NSNumber * nonce;

@end
