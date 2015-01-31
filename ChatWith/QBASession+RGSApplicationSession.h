//
//  QBASession+RGSApplicationSession.h
//  ChatWith
//
//  Created by PC on 1/31/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Quickblox/Quickblox.h>
@class RGSApplicationSession;

@interface QBASession (RGSApplicationSession)
-(RGSApplicationSession *)rgsApplicationSession;
@end
