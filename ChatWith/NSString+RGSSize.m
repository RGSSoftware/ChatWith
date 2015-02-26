//
//  NSString+RGSSize.m
//  ChatWith
//
//  Created by PC on 2/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "NSString+RGSSize.h"
#import "NSString+RGSAttributedString.h"

@implementation NSString (RGSSize)
-(CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font{
    // Let's make an NSAttributedString first
    NSMutableAttributedString *attributedString = [[self attributedString] mutableCopy];
    //Add LineBreakMode
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, attributedString.length)];
    
    //Now let's make the Bounding Rect
    CGRect expectedRect = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    return CGRectMake(expectedRect.origin.x,
                      expectedRect.origin.y,
                      ceilf(expectedRect.size.width),
                      ceilf(expectedRect.size.height));
}

@end
