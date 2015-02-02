//
//  NSString+RGSSize.h
//  ChatWith
//
//  Created by PC on 2/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RGSSize)
-(CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font;

@end
