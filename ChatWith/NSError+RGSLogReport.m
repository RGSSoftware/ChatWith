//
//  NSError+RGSLogReport.m
//  ChatWith
//
//  Created by PC on 2/4/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "NSError+RGSLogReport.h"
#import "RGSLogService.h"

@implementation NSError (RGSLogReport)

-(RGSLogReport *)logReport{
    RGSLogReport *logReport = [RGSLogReport MR_createEntity];
    logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    logReport.domain = self.domain;
    logReport.code = [NSNumber numberWithInt:self.code];
    logReport.errorDescription = self.localizedDescription;
    logReport.failureReason = self.localizedFailureReason;
    
    return logReport;
}

@end
