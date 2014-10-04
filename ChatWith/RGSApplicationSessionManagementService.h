//
//  RGSApplicationSessionManagementService.h
//  ChatWith
//
//  Created by PC on 10/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGSApplicationSessionManagementService : NSObject <QBActionStatusDelegate>

@property (nonatomic)NSUInteger applicationID;
@property (nonatomic, strong)NSString *authorizationKey;
@property (nonatomic, strong)NSString *authorizationSecret;

-(void)createSessionWithCompletion:(void (^)(BOOL success))completion;

@end
