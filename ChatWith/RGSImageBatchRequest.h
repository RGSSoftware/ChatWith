//
//  RGSImageBatchUploadRequest.h
//  ChatWith
//
//  Created by PC on 12/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RGSMessage;

@interface RGSImageBatchRequest : NSObject

-(void)uploadImagesWithMessage:(RGSMessage *)message
          successBlock:(void(^)(NSSet *customObjects))successBlock
           statusBlock:(void(^)(NSInteger status))statusBlock
            errorBlock:(void(^)(NSError *error))errorBlock;


-(void)downloadImagesWithQBMessage:(QBChatMessage *)qBMessage
                      successBlock:(void(^)(NSSet *images))successBlock
                       statusBlock:(void(^)(NSInteger status))statusBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;

-(void)startUpload;
-(void)startDownload;

@end
