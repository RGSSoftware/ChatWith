//
//  NSAttributedString+RGSAttributedStringWithExtras.h
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (RGSExtras)
+(NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment
                                                 Font:(UIFont *)font
                                                Color:(UIColor *)color;



-(NSAttributedString *)attributedStringWithFont:(UIFont *)font;
-(NSAttributedString *)attributedStringWithColor:(UIColor *)color;

-(NSAttributedString *)attributedStringWithFont:(UIFont *)font Color:(UIColor *)color;



@end
