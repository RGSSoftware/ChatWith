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
//pervert UIView backgroundColor from disappearing when UITableViewCell is selected
//http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected#21661997
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.alertBadge.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.alertBadge.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.alertBadge.backgroundColor;
    [super setSelected:selected animated:animated];
    self.alertBadge.backgroundColor = backgroundColor;
}
@end
