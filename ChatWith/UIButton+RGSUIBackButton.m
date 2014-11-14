//
//  UIButton+RGSUIBackButton.m
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "UIButton+RGSUIBackButton.h"
#import "UIImage+Resize.h"

@implementation UIButton (RGSUIBackButton)

@dynamic titleLeftEdgeInset;
@dynamic imageLeftEdgeInset;

+(UIButton *)buttonWithCustomBackButton{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 20, 80, 32)];
    
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor]
                 forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    UIImage *image = [UIImage imageNamed:@"backButton"];
    [button setImage:[image resizedImage:CGSizeMake(20, 20)]
            forState:UIControlStateNormal];
    return button;
}

-(void)setTitleLeftEdgeInset:(CGFloat)titleLeftEdgeInset{
    self.titleEdgeInsets = UIEdgeInsetsMake(2, titleLeftEdgeInset, 2, 0);
}
-(void)setImageLeftEdgeInset:(CGFloat)imageLeftEdgeInset{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageLeftEdgeInset, 2, 0);
}

@end