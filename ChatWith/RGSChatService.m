//
//  RGSChatService.m
//  ChatWith
//
//  Created by PC on 10/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatService.h"
#import "RGSChat.h"
#import "RGSManagedUser.h"
#import "RGSMessage.h"
#import "ApplicationSession.h"

#import "LocalStorageService.h"


@interface RGSChatService () <QBChatDelegate, QBActionStatusDelegate>
@property (nonatomic, strong)void(^loginSuccessBlock)(BOOL success);
@property (nonatomic, strong)void(^getConversationSuccessBlock)(BOOL success, NSArray *);
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

- (void)completedWithResult:(Result *)result{
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        self.getConversationSuccessBlock(YES, pagedResult.dialogs);
        self.getConversationSuccessBlock = nil;
        
    }
}

-(void)allConversationsFromUser:(RGSManagedUser *)user startingAt:(NSDate *)startDate successBlock:(void (^)(BOOL, NSArray *))successBlock{
    self.getConversationSuccessBlock = successBlock;
    
    NSMutableDictionary *extendedRequest = [NSMutableDictionary new];
    extendedRequest[@"last_message_date_sent[gt]"] = startDate;
    extendedRequest[@"occupants_ids"] = user.externalUserID;
                    
                    
    [QBChat dialogsWithExtendedRequest:extendedRequest  delegate:self];

}

-(void)sendMessage:(RGSMessage *)message{
    QBChatMessage *qbMessage = [QBChatMessage message];
    qbMessage.text = message.body;
    qbMessage.recipientID = [message.receiver.entityID integerValue];
    qbMessage.senderID = [message.sender.entityID integerValue];

    [[QBChat instance] sendMessage:qbMessage];
    
}

- (void)chatDidReceiveMessage:(QBChatMessage *)qbMessage{
    NSArray *users = [RGSManagedUser MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(%K = %@) OR (%K = %@)",
                                                              NSStringFromSelector(@selector(entityID)),
                                                              [NSNumber numberWithInteger:qbMessage.senderID],
                                                              NSStringFromSelector(@selector(entityID)),
                                                              [NSNumber numberWithInteger:qbMessage.recipientID]]];
    
    RGSManagedUser *sender;
    RGSManagedUser *receiver;
    
    
    RGSMessage *message = [RGSMessage MR_createEntity];
    for(RGSManagedUser *user in users){
        if([[NSNumber numberWithUnsignedInteger:qbMessage.senderID] isEqualToNumber:user.entityID]){
            sender = user;
        } else receiver = user;
    }
    
    message.sender = sender;
    message.receiver = receiver;
    message.body = qbMessage.text;
    
    
    NSPredicate *chatPredicate = [NSPredicate predicateWithFormat:@"(%@ IN %K) AND (%@ IN %K)", sender, @"participants", receiver, @"participants"];
    RGSChat *chat = [RGSChat MR_findFirstWithPredicate:chatPredicate];
    
    message.chat = chat;

    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];

}
@end
