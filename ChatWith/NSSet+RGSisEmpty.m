//
//  NSSet+RGSisEmpty.m
//  ChatWith
//
//  Created by PC on 12/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSSet+RGSisEmpty.h"

@implementation NSSet (RGSisEmpty)
-(BOOL)isEmpty{
return ((self.count > 0) ? NO : YES);
}

@end
