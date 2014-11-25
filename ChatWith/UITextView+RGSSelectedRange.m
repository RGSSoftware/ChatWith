//
//  UITextView+RGSSelectedRange.m
//  ChatWith
//
//  Created by PC on 11/24/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "UITextView+RGSSelectedRange.h"

@implementation UITextView (RGSSelectedRange)

- (void)setSelectedRange:(NSRange)selectedRange
{
    UITextPosition* from = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location];
    UITextPosition* to = [self positionFromPosition:from offset:selectedRange.length];
    self.selectedTextRange = [self textRangeFromPosition:from toPosition:to];
}

- (NSRange)selectedRange
{
    UITextRange* range = self.selectedTextRange;
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:range.start];
    NSInteger length = [self offsetFromPosition:range.start toPosition:range.end];
    NSAssert(location >= 0, @"Location is valid.");
    NSAssert(length >= 0, @"Length is valid.");
    return NSMakeRange(location, length);
}

@end
