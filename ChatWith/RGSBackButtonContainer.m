//
//  RGSBackButtonContainer.m
//  ChatWith
//
//  Created by PC on 2/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSBackButtonContainer.h"

@interface RGSBackButtonContainer ()
@property (nonatomic, strong) void(^touchUpInsideHandle)(id sender);
@end

@implementation RGSBackButtonContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action
{
    self = [super init];
    if (self) {
        
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrow"]];
        _arrow.highlightedImage = [UIImage imageNamed:@"backArrowHightlight"];
        _arrow.frame = CGRectMake(-5, 9, CGRectGetWidth(_arrow.frame)/3, CGRectGetHeight(_arrow.frame)/3);
        
        
        
        _label = [UILabel labelWithText:title];
        _label.frame = CGRectMake(8, 12, 50, 20);
        _label.textColor = [UIColor whiteColor];
        
        _label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16];
        
        CGSize labelWidth = [_label.text sizeWithAttributes:@{NSFontAttributeName:_label.font}];
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_arrow.frame) + ceilf(labelWidth.width), 44);
        
        [self addSubview:_arrow];
        [self addSubview:_label];
        
        _touchUpInsideHandle = action;
        
    }
return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 20;
    rect.size.width = rect.size.width + 16;
    if(CGRectContainsPoint(rect, [touch locationInView:nil])){
        self.label.textColor = [UIColor lightGrayColor];
        self.arrow.highlighted = YES;
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(!CGRectContainsPoint(self.frame, [touch locationInView:self])){
        self.label.textColor = [UIColor whiteColor];
        self.arrow.highlighted = NO;
    } else {
        //        self.label.textColor = [UIColor yellowColor];
        self.label.textColor = [UIColor lightGrayColor];
        self.arrow.highlighted = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 20;
    rect.size.width = rect.size.width + 16;
    if(CGRectContainsPoint(rect, [touch locationInView:nil])){
        if(self.touchUpInsideHandle != nil) self.touchUpInsideHandle(self);
    }
    
    self.label.textColor = [UIColor whiteColor];
    self.arrow.highlighted = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.label.textColor = [UIColor whiteColor];
    self.arrow.highlighted = NO;
}




@end
