//
//  RGSImageBatchUploadRequest.m
//  ChatWith
//
//  Created by PC on 12/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSImageBatchRequest.h"

#import "RGSMessage.h"
#import "RGSImage.h"

NSString *const messageImageClass = @"MessageImage";
NSString *const messageImagePropertyIndex = @"index";
NSString *const messageImagePropertyImage = @"image";

@interface RGSOpertion : NSObject
@property (nonatomic, strong)QBCOCustomObject *object;

@property (nonatomic, strong)NSData *fileData;

@property (nonatomic)BOOL isCompleted;
@property (nonatomic)float percentOfCompletion;
@property (nonatomic, strong)NSError *error;
@end

@implementation RGSOpertion
@end


static int completedOpertionsCount(NSArray *opertions){
    int completedOpertions = 0;
    for (RGSOpertion *opetion in opertions) {
        if (opetion.isCompleted) {
            completedOpertions++;
        }
    }
    return completedOpertions;
}

static BOOL isOpertionsComplete(NSArray *opertions){
    return (completedOpertionsCount(opertions) == opertions.count) ? YES : NO;
}

@interface RGSImageBatchRequest ()

@property (nonatomic, strong)RGSMessage *rgsMesssage;
@property (nonatomic, strong)QBChatMessage *qbMessage;

@property (nonatomic, strong)void(^successUploadBlock)(NSSet *customObjects);
@property (nonatomic, strong)void(^successDownloadBlock)(NSSet *image);
@property (nonatomic, strong)void(^statusBlock)(NSInteger status);
@property (nonatomic, strong)void(^errorBlock)(NSError *error);

@property (nonatomic, strong)NSMutableArray *uploadOpertions;
@property (nonatomic, strong)NSMutableArray *downloadOpertions;

@property (nonatomic, strong)NSTimer *checkTimer;
@end

@class RGSMessage;

@implementation RGSImageBatchRequest

-(id)init{
    if (self) {
        _uploadOpertions = [NSMutableArray new];
        _downloadOpertions = [NSMutableArray new];
    }
    return self;
}

-(void)uploadImagesWithMessage:(RGSMessage *)message
                  successBlock:(void (^)(NSSet *))successBlock
                   statusBlock:(void (^)(NSInteger))statusBlock
                    errorBlock:(void (^)(NSError *))errorBlock{
    self.rgsMesssage = message;
    self.successUploadBlock = successBlock;
    self.statusBlock = statusBlock;
    self.errorBlock = errorBlock;
}

-(void)downloadImagesWithQBMessage:(QBChatMessage *)qBMessage
                      successBlock:(void (^)(NSSet *))successBlock
                       statusBlock:(void (^)(NSInteger))statusBlock
                        errorBlock:(void (^)(NSError *))errorBlock{
    
    self.qbMessage = qBMessage;
    self.successDownloadBlock = successBlock;
    self.statusBlock = statusBlock;
    self.errorBlock = errorBlock;
}

-(void)startUpload{
    for (RGSImage *image in self.rgsMesssage.images) {
        QBCOFile *file = [QBCOFile file];
        file.name = @"image";
        file.contentType = @"image/jpeg";
        file.data = image.imageData;
        
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = messageImageClass;
        object.fields[messageImagePropertyIndex] = image.index;
        
        RGSOpertion *uploadOpertion = [RGSOpertion new];
        uploadOpertion.object = object;
        [self.uploadOpertions addObject:uploadOpertion];
        
        [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            
            [QBRequest uploadFile:file className:messageImageClass objectID:object.ID fileFieldName:messageImagePropertyImage successBlock:^(QBResponse *response, QBCOFileUploadInfo *info) {
            
                uploadOpertion.object = object;
                uploadOpertion.isCompleted = YES;
                NSLog(@"file image upload: Resonse status: %d", response.status);
                
            } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                uploadOpertion.percentOfCompletion = status.percentOfCompletion;
                
            } errorBlock:^(QBResponse *response) {
                NSLog(@"creating file Image: Response error: %@", [response.error description]);
                [self.checkTimer invalidate];
                if (self.errorBlock) self.errorBlock(response.error.error);
            }];
        } errorBlock:^(QBResponse *response) {
            NSLog(@"creating MessageImage: Response error: %@", [response.error description]);
            [self.checkTimer invalidate];
            if (self.errorBlock) self.errorBlock(response.error.error);
        }];
    }
    
      self.checkTimer = [NSTimer bk_scheduledTimerWithTimeInterval:.5 block:^(NSTimer *timer) {
        [self observeUploadStatus];
    } repeats:YES];

}

-(void)startDownload{
    for (QBChatAttachment *attachment in self.qbMessage.attachments) {
        RGSOpertion *downloadOpertion = [RGSOpertion new];
        [self.downloadOpertions addObject:downloadOpertion];
        [QBRequest objectWithClassName:messageImageClass ID:attachment.ID  successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            
            downloadOpertion.object = object;
            
            [QBRequest downloadFileFromClassName:messageImageClass objectID:object.ID fileFieldName:messageImagePropertyImage successBlock:^(QBResponse *response, NSData *loadedData) {
                
                downloadOpertion.fileData = loadedData;
                downloadOpertion.isCompleted = YES;
                
            } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                downloadOpertion.percentOfCompletion = status.percentOfCompletion;

            } errorBlock:^(QBResponse *response) {
                NSLog(@"downloading file image: Response error: %@", [response.error description]);
                [self.checkTimer invalidate];
                if (self.errorBlock) {
                    if (self.errorBlock) self.errorBlock(response.error.error);
                }
            }];
        } errorBlock:^(QBResponse *response) {
            NSLog(@"downloading MessageImage: Response error: %@", [response.error description]);
            [self.checkTimer invalidate];
            if (self.errorBlock) self.errorBlock(response.error.error);
        }];
    }
    
    self.checkTimer = [NSTimer bk_scheduledTimerWithTimeInterval:.5 block:^(NSTimer *timer) {
        [self observeDownloadStatus];
    } repeats:YES];
}

-(void)observeDownloadStatus{
    if (isOpertionsComplete(self.downloadOpertions)) {
        [self.checkTimer invalidate];
        
        NSMutableSet *images = [NSMutableSet new];
        for(RGSOpertion *opetion in self.downloadOpertions){
            RGSImage *image = [RGSImage MR_createEntity];
            image.imageData = opetion.fileData;
            image.index = opetion.object.fields[messageImagePropertyIndex];
            [images addObject:image];
        }
        if (self.successDownloadBlock) self.successDownloadBlock(images);
    }
}

-(void)observeUploadStatus{
    if (isOpertionsComplete(self.uploadOpertions)) {
        [self.checkTimer invalidate];
        
        NSMutableSet *customObjects = [NSMutableSet new];
        for(RGSOpertion *opetion in self.uploadOpertions){
            [customObjects addObject:opetion.object];
        }
        if (self.successUploadBlock) self.successUploadBlock(customObjects);
    }
}
@end

