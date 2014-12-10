//
//  NSMutableAttributedString+RGSAlignment.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "NSMutableAttributedString+RGSAlignment.h"

@implementation NSMutableAttributedString (RGSAlignment)
-(void)setAlignment:(NSTextAlignment)textAlignment{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:textAlignment];
    
    [self beginEditing];
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    [self endEditing];
}

-(void)setColor:(UIColor *)color{
    [self beginEditing];
    [self removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [self length])];
    [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [self length])];
    [self endEditing];
    
}

@end
