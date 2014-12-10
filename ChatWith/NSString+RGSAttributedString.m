//
//  NSString+RGSAttributedString.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSString+RGSAttributedString.h"

@implementation NSString (RGSAttributedString)

-(NSAttributedString *)attributedString{
    return [[NSAttributedString alloc] initWithString:self];
}
@end
