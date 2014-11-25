//
//  NSAttributedString+RGSAttributedStringWithExtras.h
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (RGSAttributedStringWithExtras)
+(NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment
                                                 Font:(UIFont *)font
                                                Color:(UIColor *)color;

@end
