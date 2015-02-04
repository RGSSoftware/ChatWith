//
//  RGSLogReport.h
//  ChatWith
//
//  Created by PC on 2/4/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


NSString * const LogReportLevelMain;
NSString * const LogReportLevelSub;


@interface RGSLogReport : NSManagedObject

@property (nonatomic, retain) NSString * failureReason;
@property (nonatomic, retain) NSString * systemVersionNumber;
@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * errorDescription;
@property (nonatomic, retain) RGSLogReport *subReport;

+(instancetype)logReportFromErrorDic:(NSDictionary *)errorDic;

@end
