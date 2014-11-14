//
//  RGSChatCell.m
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatCell.h"

@implementation RGSChatCell

-(UIView *)customSelectedBackgroundViewWithFrame:(CGRect)frame{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.506 alpha:0.230];
    return selectedBackgroundView;
}
@end
