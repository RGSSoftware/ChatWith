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

-(NSAttributedString *)attributedStringWithColor:(UIColor *)color{
    NSMutableAttributedString* attributedString = [self mutableCopy];
    
    {
        [attributedString beginEditing];
        
        [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            
            [attributedString removeAttribute:NSForegroundColorAttributeName range:range];
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }];
        
        [attributedString endEditing];
    }
    
    return [attributedString copy];
    
}



@end
