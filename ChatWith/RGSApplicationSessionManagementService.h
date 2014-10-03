//
//  RGSApplicationSessionManagementService.h
//  ChatWith
//
//  Created by PC on 10/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGSApplicationSessionManagementService : NSObject <QBActionStatusDelegate>

-(void)createSessionWithCompletion:(void (^)(BOOL success))completion;

@end
