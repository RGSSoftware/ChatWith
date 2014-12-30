//
//  RGSBarButtonItem.m
//  ChatWith
//
//  Created by PC on 12/30/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBarButtonItem.h"

@interface RGSBarButtonItem ()

@property UIButton *button;
@end

@implementation RGSBarButtonItem

-(void)setTitle:(NSString *)title{
    [self.button setTitle:title forState:UIControlStateNormal];
}
-(NSString *)title{
    return self.button.titleLabel.text;
}

-(void)setTitleColor:(UIColor *)textColor{
    [self.button setTitleColor:textColor forState:UIControlStateNormal];
}
-(UIColor *)titleColor{
    return [self.button titleColorForState:UIControlStateNormal];
}

-(void)setImage:(UIImage *)image{
    [self.button setImage:image
            forState:UIControlStateNormal];
}

-(UIImage *)image{
    return self.button.imageView.image;
}

-(void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets{
    self.button.titleEdgeInsets = titleEdgeInsets;
}
-(UIEdgeInsets)titleEdgeInsets{
    return self.button.titleEdgeInsets;
}

-(void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets{
    self.button.imageEdgeInsets = imageEdgeInsets;
}

-(UIEdgeInsets)imageEdgeInsets{
    return self.button.imageEdgeInsets;
}
-(void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment{
    [self.button setContentHorizontalAlignment:contentHorizontalAlignment];
}

-(UIControlContentHorizontalAlignment)contentHorizontalAlignment{
    return self.button.contentHorizontalAlignment;
}

-(void)addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)controlEvent{
    [self.button addTarget:target action:selector forControlEvents:controlEvent];
}

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action{
    self = [super init];
    if (self) {
        [self baseInit];
        
        [_button bk_addEventHandler:action forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:title forState:UIControlStateNormal];
    }
    return self;
    
    
}
-(instancetype)initWithHandler:(void (^)(id))action{
    self = [super init];
    if (self) {
        [self baseInit];
        
        [_button bk_addEventHandler:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    
    
    return self;
}

-(void)baseInit{
    _button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:CGRectMake(0, 20, 80, 32)];
    
    [_button setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor lightGrayColor]
                  forState:UIControlStateHighlighted];
    _button.titleLabel.textAlignment = NSTextAlignmentLeft;
    _button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    self.customView = _button;
}

@end
