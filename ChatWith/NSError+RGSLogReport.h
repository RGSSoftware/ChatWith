//
//  NSError+RGSLogReport.h
//  ChatWith
//
//  Created by PC on 2/4/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RGSLogReport;

@interface NSError (RGSLogReport)

-(RGSLogReport *)logReport;
@end
