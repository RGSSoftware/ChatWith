//
//  RGSLogReport.h
//  ChatWith
//
//  Created by PC on 2/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RGSLogReport : NSManagedObject

typedef NS_ENUM(NSInteger, UserRequest){
    UserRequestSendMessage,
    UserRequestLogin
};


@property (nonatomic, retain) NSString * systemVersionNumber;
@property (nonatomic) int32_t userRequest;
@property (nonatomic, retain) NSString * failureReason;

@end
