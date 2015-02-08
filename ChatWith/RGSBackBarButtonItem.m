//
//  RGSBackBarButtonItem.m
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBackBarButtonItem.h"
#import "UIImage+Resize.h"
#import "RGSBackButtonContainer.h"

@interface RGSBackBarButtonItem ()



@property UIView *container;

@property (nonatomic, strong) void(^touchUpInsideHandle)(id sender);

@end

@implementation RGSBackBarButtonItem
-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action{
    self = [super init];
    if (self) {
        
        
//        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrowlarger2"]];
//        _arrow.highlightedImage = [UIImage imageNamed:@"backArrowlarger2hightlighted"];
//        _arrow.frame = CGRectMake(-5, 15, CGRectGetWidth(_arrow.frame)/3, CGRectGetHeight(_arrow.frame)/3);
//        
//        
//        
//        _label = [UILabel labelWithText:title];
//        _label.frame = CGRectMake(8, 18, 50, 20);
//        _label.textColor = [UIColor whiteColor];
//        
//        _label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16];
//        
//        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 53)];
//        [_container addSubview:_arrow];
//        [_container addSubview:_label];
        
        
        
//        _container.layer.borderWidth = 1;
        
        self.customView = [[RGSBackButtonContainer alloc] initWithTitle:title handler:action];
        NSLog(@"simple print-----container.frame------{%@}", _container);
        
        self.touchUpInsideHandle = action;
    }
    return self;

}

-(instancetype)initWithHandler:(void (^)(id))action{
    self = [super init];
    if (self) {
        
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrowlarger2"]];
        _arrow.highlightedImage = [UIImage imageNamed:@"backArrowlarger2hightlighted"];
        _arrow.frame = CGRectMake(10, 20, CGRectGetWidth(_arrow.frame)/3, CGRectGetHeight(_arrow.frame)/3);
        
        _label = [UILabel labelWithText:@""];
        _label.frame = CGRectMake(CGRectGetWidth(_arrow.frame) + 10, 25, 30, 20);
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 53)];
        [_container addSubview:_arrow];
        [_container addSubview:_label];
        
        self.customView = _container;
        
        self.touchUpInsideHandle = action;
    }
    return self;

    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrowlarger2"]];
        _arrow.highlightedImage = [UIImage imageNamed:@"backArrowlarger2hightlighted"];
        _arrow.frame = CGRectMake(10, 20, CGRectGetWidth(_arrow.frame)/3, CGRectGetHeight(_arrow.frame)/3);
        
        _label = [UILabel labelWithText:@""];
        _label.frame = CGRectMake(CGRectGetWidth(_arrow.frame) + 10, 25, 30, 20);
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 53)];
        [_container addSubview:_arrow];
        [_container addSubview:_label];
        
        self.customView = _container;
    }
    return self;
}



@end
