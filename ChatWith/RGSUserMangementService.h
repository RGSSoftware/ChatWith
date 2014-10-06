//
//  RGSUserLoginDelegate.h
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGSLoginViewController.h"


@interface RGSUserMangementService : NSObject <QBActionStatusDelegate>


-(void)registerUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL success))success;
-(void)loginUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL success))success;
-(void)isUsernameTaken:(NSString *)username successBlock:(void (^)(BOOL isTaken))results;
@end


