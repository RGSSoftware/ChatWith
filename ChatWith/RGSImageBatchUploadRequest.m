//
//  RGSImageBatchUploadRequest.m
//  ChatWith
//
//  Created by PC on 12/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSImageBatchUploadRequest.h"

#import "RGSMessage.h"
#import "RGSImage.h"

@interface RGSImageUploadOpertion : NSObject 
@property (nonatomic, strong)QBCOCustomObject *object;

@property (nonatomic)BOOL isCompleted;
@property (nonatomic)float percentOfCompletion;
@property (nonatomic, strong)NSError *error;
@end

@implementation RGSImageUploadOpertion



@end

@interface RGSImageBatchUploadRequest ()

@property (nonatomic, strong)RGSMessage *messsage;
@property (nonatomic, strong)void(^successBlock)(NSSet *customObjects);
@property (nonatomic, strong)void(^statusBlock)(NSInteger status);
@property (nonatomic, strong)void(^errorBlock)(NSError *error);

@property (nonatomic, strong)NSMutableArray *uploadOpertions;

@property (nonatomic, strong)NSTimer *timer;
@end

@class RGSMessage;

@implementation RGSImageBatchUploadRequest
-(id)initWithMessage:(RGSMessage *)message
        successBlock:(void(^)(NSSet *customObjects))successBlock
         statusBlock:(void(^)(NSInteger status))statusBlock
          errorBlock:(void(^)(NSError *error))errorBlock{
    self = [super init];
    if (self) {
        _messsage = message;
        
        _successBlock = successBlock;
        _statusBlock = statusBlock;
        _errorBlock = errorBlock;
        
        _uploadOpertions = [NSMutableArray new];
    }
    return self;
}

-(void)startUpload{
    
    NSMutableDictionary *successUploadImage = [NSMutableDictionary dictionary];
    
    
    for (RGSImage *image in self.messsage.images) {
        QBCOFile *file = [QBCOFile file];
        file.name = @"image";
        file.contentType = @"image/jpeg";
        file.data = image.imageData;
        
        
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = @"MessageImage";
        object.fields[@"index"] = image.index;
        
        RGSImageUploadOpertion *uploadOpertion = [RGSImageUploadOpertion new];
        uploadOpertion.object = object;
        [self.uploadOpertions addObject:uploadOpertion];
        
        [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // do something when object is successfully created on a server
            
            [QBRequest uploadFile:file className:@"MessageImage" objectID:object.ID fileFieldName:@"image" successBlock:^(QBResponse *response, QBCOFileUploadInfo *info) {
                successUploadImage[object.ID] = object;
                
                uploadOpertion.isCompleted = YES;
                NSLog(@"simple print-----file iamge upload is good------");
                
            } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                uploadOpertion.percentOfCompletion = status.percentOfCompletion;
                
            } errorBlock:^(QBResponse *response) {
                NSLog(@"creating file Image: Response error: %@", [response.error description]);
            }];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"creating MessageImage: Response error: %@", [response.error description]);
        }];
    }
    
//    [self observeUploadStatus];
      self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:.5 block:^(NSTimer *timer) {
        [self observeUploadStatus];
    } repeats:YES];

}

-(void)observeUploadStatus{
    BOOL isAllOpertionsCompleted = NO;
    int completedOpertions = 0;
    
        for (RGSImageUploadOpertion *opetion in self.uploadOpertions) {
            if (opetion.isCompleted) {
                completedOpertions++;
            }
        }
        if (completedOpertions == self.messsage.images.count) {
            [self.timer invalidate];
            
            isAllOpertionsCompleted = YES;
            
            NSMutableSet *customObjects = [NSMutableSet new];
            for(RGSImageUploadOpertion *opetion in self.uploadOpertions){
                [customObjects addObject:opetion.object];
            }
            self.successBlock(customObjects);
        } else {
            completedOpertions = 0;
            isAllOpertionsCompleted = NO;
        }
}

@end

