//
//  RGSBackBarButtonItem.m
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBackBarButtonItem.h"
#import "UIImage+Resize.h"

@interface RGSBackBarButtonItem ()

@property UIButton *button;
@end

@implementation RGSBackBarButtonItem
+(instancetype)new{
    RGSBackBarButtonItem *bck = [[RGSBackBarButtonItem alloc] init];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 20, 80, 32)];
    
    [button setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor]
                  forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    UIImage *image = [UIImage imageNamed:@"backArrow"];
    [button setImage:[image resizedImage:CGSizeMake(12, 25)]
             forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, -2, 2, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 2, 0);
    
    bck.button = button;
    bck.customView = button;
    return bck;
    
}
-(void)addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)controlEvent{
    [self.button addTarget:target action:selector forControlEvents:controlEvent];
}
-(void)setTitle:(NSString *)title{
    [self.button setTitle:title forState:UIControlStateNormal];
}

-(void)bar{
    
}

@end
