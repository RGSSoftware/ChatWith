//
//  RGSUserLoginDelegate.h
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGSLoginViewController.h"

@interface RGSUserLoginDelegate : NSObject <LoginViewControllerDelegate, QBActionStatusDelegate>

@property (nonatomic,strong)Class qBSUsers;

-(void)isUsernameTaken:(NSString *)username successBlock:(void (^)(BOOL isTaken))results;
@end
