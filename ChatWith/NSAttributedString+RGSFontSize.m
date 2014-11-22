//
//  NSAttributedString+RGSFontSize.m
//  ChatWith
//
//  Created by PC on 11/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSAttributedString+RGSFontSize.h"

@implementation NSAttributedString (RGSFont)

- (NSAttributedString*) attributedStringWithFont:(UIFont *)font
{
    NSMutableAttributedString* attributedString = [self mutableCopy];
    
    {
        [attributedString beginEditing];
        
        [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            
            [attributedString removeAttribute:NSFontAttributeName range:range];
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
        }];
        
        [attributedString endEditing];
    }
    
    return [attributedString copy];
}

- (NSAttributedString*) attributedStringWithFont:(UIFont *)font Color:(UIColor *)color{
    {
        NSMutableAttributedString* attributedString = [self mutableCopy];
        
        {
            [attributedString beginEditing];
            
            [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                
                [attributedString removeAttribute:NSFontAttributeName range:range];
                [attributedString removeAttribute:NSForegroundColorAttributeName range:range];
                
                [attributedString addAttribute:NSFontAttributeName value:font range:range];
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
            }];
            
            [attributedString endEditing];
        }
        
        return [attributedString copy];
    }
    
}

@end
