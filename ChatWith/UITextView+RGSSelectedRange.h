//
//  UITextView+RGSSelectedRange.h
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (RGSSelectedRange)
- (void)setSelectedRange:(NSRange)selectedRange;
- (NSRange)selectedRange;

@end
