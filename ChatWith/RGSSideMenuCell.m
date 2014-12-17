//
//  RGSSideMenuCell.m
//  ChatWith
//
//  Created by PC on 12/16/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSideMenuCell.h"
#import "UIColor+RGSColorWithHexString.h"

@implementation RGSSideMenuCell

- (void)awakeFromNib {
    // Initialization code
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    self.selectedBackgroundView = view;
    
    self.menuLabel.textColor = [UIColor colorWithWhite:0.901 alpha:1.000];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        self.menuLabel.textColor = [UIColor whiteColor];
        
        self.icon.hidden = YES;
        self.iconSelected.hidden = NO;
    } else {
        self.menuLabel.textColor = [UIColor colorWithWhite:0.901 alpha:1.000];
        
        self.icon.hidden = NO;
        self.iconSelected.hidden = YES;
        
    }
    // Configure the view for the selected state
}

@end
