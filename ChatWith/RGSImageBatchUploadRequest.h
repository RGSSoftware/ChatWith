//
//  RGSImageBatchUploadRequest.h
//  ChatWith
//
//  Created by PC on 12/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RGSMessage;

@interface RGSImageBatchUploadRequest : NSObject

-(id)initWithMessage:(RGSMessage *)message
        successBlock:(void(^)(NSSet *customObjects))successBlock
         statusBlock:(void(^)(NSInteger status))statusBlock
          errorBlock:(void(^)(NSError *error))errorBlock;

-(void)startUpload;

@end
