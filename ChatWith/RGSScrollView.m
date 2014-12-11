//
//  RGSScrollView.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSScrollView.h"

@implementation RGSScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
    }
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:UIButton.class] || [view isKindOfClass:UITextField.class]) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
