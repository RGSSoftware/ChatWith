//
//  NSAttributedString+RGSAttributedStringWithExtras.m
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSAttributedString+RGSExtras.h"


@implementation NSAttributedString (RGSExtras)

+(NSAttributedString *)attributedStringWithAttachment:(NSTextAttachment *)attachment
                                                 Font:(UIFont *)font
                                                Color:(UIColor *)color{
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    return [attrStringWithImage attributedStringWithFont:font
                                                Color:color];
    
}
+(NSAttributedString *)attributedStringWithString:(NSString *)string Color:(UIColor *)color{
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:color}];
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

-(CGRect)boundingRectWithSize:(CGSize)size {
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:[NSStringDrawingContext new]];
}

@end
