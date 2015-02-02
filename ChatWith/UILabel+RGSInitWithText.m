//
//  UILabel+RGSInitWithText.m
//  ChatWith
//
//  Created by PC on 2/2/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "UILabel+RGSInitWithText.h"

@implementation UILabel (RGSInitWithText)

+(instancetype)labelWithText:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    return label;
}

@end
