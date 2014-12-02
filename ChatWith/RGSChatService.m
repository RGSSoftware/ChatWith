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
#import "RGSImage.h"

#import "LocalStorageService.h"

#import "RGSImageBatchRequest.h"


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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [qbMessage setCustomParameters:params];
    params[@"save_to_history"] = @YES;
    
    params[@"attributed_text"] = [message.body stringByReplacingOccurrencesOfString:[NSString stringWithUTF8String:"\ufffc"]
                                                                         withString:@"{%8*IMAGE*8%}"];

    if (message.images) {
        RGSImageBatchRequest *imageBatchUpload = [[RGSImageBatchRequest alloc] init];
        
        [imageBatchUpload uploadImagesWithMessage:message successBlock:^(NSSet *customObjects) {
            
            NSMutableArray *attachments = [NSMutableArray new];
            for (QBCOCustomObject *customObject in customObjects) {
                QBChatAttachment *attachment = [QBChatAttachment new];
                attachment.type = @"image";
                attachment.ID = customObject.ID;
                
                [attachments addObject:attachment];
            }
            
            qbMessage.attachments = attachments;
            
            [[QBChat instance] sendMessage:qbMessage];
        } statusBlock:nil errorBlock:nil];
        [imageBatchUpload startUpload];
    } else {
        
        [[QBChat instance] sendMessage:qbMessage];
    }
    
    
    
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
    
    message.body = [qbMessage.customParameters[@"attributed_text"] stringByReplacingOccurrencesOfString:@"{%8*IMAGE*8%}"
                                                                                             withString:[NSString stringWithUTF8String:"\ufffc"]];

    message.date = qbMessage.datetime;
    
    NSPredicate *chatPredicate = [NSPredicate predicateWithFormat:@"(%@ IN %K) AND (%@ IN %K)", sender, @"participants", receiver, @"participants"];
    RGSChat *chat = [RGSChat MR_findFirstWithPredicate:chatPredicate];
    
    message.chat = chat;
    
    
    if (qbMessage.attachments) {
        RGSImageBatchRequest *imageBatchDownload = [[RGSImageBatchRequest alloc] init];
        
        [imageBatchDownload downloadImagesWithQBMessage:qbMessage successBlock:^(NSSet *images) {
            for (RGSImage *image in images) {
                image.message = message;
            }
            message.images = images;
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        } statusBlock:nil errorBlock:nil];
        
        [imageBatchDownload startDownload];
    } else {
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }


    

}
@end
