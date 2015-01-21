//
//  RGSLogService.h
//  ChatWith
//
//  Created by PC on 1/20/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGSLogReport.h"
@interface RGSLogService : NSObject

+(void)sendLog:(RGSLogReport *)logReport successBlock:(void (^)(BOOL success, NSError *error))successBlock;

@end
