//
//  dashBorderView.m
//  ChatWith
//
//  Created by PC on 12/17/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "dashBorderView.h"

@implementation dashBorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:0.888 alpha:0.600] CGColor]);
    
    CGFloat dashes[] = {3,3};
    
    CGContextSetLineDash(context, 0.0, dashes, 2);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextSetShouldAntialias(context, NO);
    CGContextStrokePath(context);
}


@end
