//
//  RGSUser+RGSFinder.m
//  ChatWith
//
//  Created by PC on 2/5/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSUser+RGSFinder.h"

@implementation RGSUser (RGSFinder)
+(instancetype)findCurrentUser{
    return [RGSUser MR_findFirstByAttribute:@"currentUser" withValue:@YES];
}

@end
