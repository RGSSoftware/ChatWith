//
//  NSAttributedString+RGSFontSize.h
//  ChatWith
//
//  Created by PC on 11/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (RGSFont)

- (NSAttributedString*) attributedStringWithFont:(UIFont *)font;
- (NSAttributedString*) attributedStringWithFont:(UIFont *)font Color:(UIColor *)color;

@end
