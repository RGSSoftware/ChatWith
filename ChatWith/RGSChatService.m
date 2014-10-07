//
//  RGSChatService.m
//  ChatWith
//
//  Created by PC on 10/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatService.h"

@interface RGSChatService () <QBChatDelegate>
@property (nonatomic, strong)void(^loginSuccessBlock)(BOOL success);

@property (nonatomic, strong) NSTimer *presenceTimer;
@end

@implementation RGSChatService

static RGSChatService *_instance = nil;
static dispatch_once_t once_token = 0;

+ (instancetype)shared
{
    dispatch_once(&once_token, ^{
        if (_instance == nil) {
            _instance = [[RGSChatService alloc] init];
        }
    });
    
    return _instance;
}
+(void)setSharedInstance:(RGSChatService *)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _instance = instance;
}

-(void)loginUser:(QBUUser *)user successBlock:(void (^)(BOOL))success{
    self.loginSuccessBlock = success;
    
    [QBChat instance].delegate = self;
    [[QBChat instance] loginWithUser:user];
    
}

- (void)chatDidLogin{
//     Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    
    if(self.loginSuccessBlock != nil){
        self.loginSuccessBlock(YES);
        self.loginSuccessBlock = nil;
    }
}

- (void)chatDidFailWithError:(NSInteger)code{
    
    if(self.loginSuccessBlock != nil){
        self.loginSuccessBlock(NO);
        self.loginSuccessBlock = nil;
    }
}

@end
