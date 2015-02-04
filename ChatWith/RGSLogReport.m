//
//  RGSLogReport.m
//  ChatWith
//
//  Created by PC on 2/4/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSLogReport.h"

NSString * const LogReportLevelMain = @"LogReportLevelMain";
NSString * const LogReportLevelSub = @"LogReportLevelSub";


@implementation RGSLogReport

@dynamic failureReason;
@dynamic systemVersionNumber;
@dynamic code;
@dynamic domain;
@dynamic errorDescription;
@dynamic subReport;

+(instancetype)logReportFromErrorDic:(NSDictionary *)errorDic{
    RGSLogReport *logReport;
    id mainError = [errorDic objectForKey:LogReportLevelMain];
    if(mainError){
        if([mainError isKindOfClass:[NSError class]]){
            logReport = [[errorDic objectForKey:LogReportLevelMain] logReport];
            
            id subError = [errorDic objectForKey:LogReportLevelSub];
            if(subError){
                if([subError isKindOfClass:[NSError class]]){
                    RGSLogReport *subLogReport = [[errorDic objectForKey:LogReportLevelSub] logReport];
                    
                    logReport.subReport = subLogReport;
                }
            }
        }
    }
    return logReport;
}

@end
