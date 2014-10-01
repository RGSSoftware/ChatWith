//
//  NSString+alphaOnly.m
//  FindMyPet
//
//  Created by PC on 12/5/13.
//  Copyright (c) 2013 Randel Smith. All rights reserved.
//

#import "NSString+alphaOnly.h"

@implementation NSString (alphaOnly)

- (BOOL) isAlphaNumeric
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

@end
