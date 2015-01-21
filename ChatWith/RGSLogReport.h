//
//  RGSLogReport.h
//  ChatWith
//
//  Created by PC on 1/20/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, UserRequest){
    UserRequestSendMessage
};


@interface RGSLogReport : NSManagedObject

@property (nonatomic, retain) NSString * systemVersionNumber;
@property (nonatomic, retain) NSString * failureReason;
@property (nonatomic) UserRequest userRequest;


@end
