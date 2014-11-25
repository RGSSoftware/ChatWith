//
//  NSAttributedString+RGSAttributedStringWithExtras.m
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSAttributedString+RGSAttributedStringWithExtras.h"
#import "NSAttributedString+RGSFontSize.h"

@implementation NSAttributedString (RGSAttributedStringWithExtras)

+(NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment
                                                 Font:(UIFont *)font
                                                Color:(UIColor *)color{
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    return [attrStringWithImage attributedStringWithFont:font
                                                Color:color];
    
}

@end
