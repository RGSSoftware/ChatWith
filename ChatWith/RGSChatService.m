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

#import "RGSLogReport.h"
#import "RGSLogService.h"


@interface RGSChatService () <QBChatDelegate, QBActionStatusDelegate>
@property (nonatomic, strong)void(^loginSuccessBlock)(BOOL success);
@property (nonatomic, strong)void(^getConversationSuccessBlock)(BOOL success, NSArray *);
@property (nonatomic, strong) NSTimer *presenceTimer;

@property QBChatMessage *qbMessage;
@property RGSMessage *rgsMessage;

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
    self.rgsMessage = message;
    
    self.qbMessage = [QBChatMessage message];
    self.qbMessage.text = self.rgsMessage.body;
    self.qbMessage.recipientID = [self.rgsMessage.receiver.entityID integerValue];
    self.qbMessage.senderID = [self.rgsMessage.sender.entityID integerValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.qbMessage setCustomParameters:params];
    params[@"save_to_history"] = @YES;
    
    params[@"attributed_text"] = [self.rgsMessage.body stringByReplacingOccurrencesOfString:[NSString stringWithUTF8String:"\ufffc"]
                                                                         withString:@"{%8*IMAGE*8%}"];
    
    if (self.rgsMessage.images) {
        RGSImageBatchRequest *imageBatchUpload = [[RGSImageBatchRequest alloc] init];
        
        [imageBatchUpload uploadImagesWithMessage:self.rgsMessage successBlock:^(NSSet *customObjects) {
            
            NSMutableArray *attachments = [NSMutableArray new];
            for (QBCOCustomObject *customObject in customObjects) {
                QBChatAttachment *attachment = [QBChatAttachment new];
                attachment.type = @"image";
                attachment.ID = customObject.ID;
                
                [attachments addObject:attachment];
            }
            
            self.qbMessage.attachments = attachments;
            
           [self sendQBMessage];
        } statusBlock:nil errorBlock:nil];
        [imageBatchUpload startUpload];
    } else {
        [self sendQBMessage];
    }
  
}
-(void)sendQBMessage{
    if(!self.rgsMessage || !self.qbMessage) return;
    
    [[QBChat instance] sendMessage:self.qbMessage sentBlock:^(NSError *error) {
        if(!error){
            self.rgsMessage.sendStatus = SendStatusSent;
            [self.rgsMessage.managedObjectContext MR_saveOnlySelfWithCompletion:nil];
        } else {
            self.rgsMessage.sendStatus = SendStatusError;
            
            RGSLogReport *logReport = [RGSLogReport MR_createEntity];
            logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            logReport.userRequest = UserRequestSendMessage;
            logReport.failureReason = [error localizedFailureReason];
            [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                if(success)[RGSLogService sendLog:logReport successBlock:nil];
            }];
        }
        
    }];
    
    
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
            NSMutableArray *messageImages = [NSMutableArray new];

            for (RGSImage *image in images) {
                image.message = message;
                
                RGSMessage *messageImage = [RGSMessage MR_createEntity];
                messageImage.sender = sender;
                messageImage.receiver = receiver;
                messageImage.chat = chat;
                messageImage.body = [NSString stringWithUTF8String:"\ufffc"];
                messageImage.image = image;
                
                image.messageImage = messageImage;
                
                [messageImages addObject:messageImages];

            }
            message.images = images;
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        } statusBlock:nil errorBlock:nil];
        
        [imageBatchDownload startDownload];
    } else {
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }
}
-(BOOL)canReach{
   return  [[Reachability reachabilityWithHostName:@"www.quickblox.com"] isReachable];
}
@end
