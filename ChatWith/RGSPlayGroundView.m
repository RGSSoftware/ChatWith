//
//  RGSPlayGroundView.m
//  ChatWith
//
//  Created by PC on 2/7/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSPlayGroundView.h"

@interface RGSPlayGroundView ()

//@property (nonatomic, weak)IBOutlet UILabel *label;
//@property (nonatomic, weak)IBOutlet UIImageView *arrow;

@end

@implementation RGSPlayGroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
//    self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrowlarger2"]];
//    self.arrow.highlightedImage = [UIImage imageNamed:@"backArrowlarger2hightlighted"];
//    self.arrow.frame = CGRectMake(65, 20, CGRectGetWidth(self.arrow.frame)/3, CGRectGetHeight(self.arrow.frame)/3);
//    [self addSubview:self.arrow];
    
    self.layer.cornerRadius = 10;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.label.textColor = [UIColor lightGrayColor];
    self.arrow.highlighted = YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(!CGRectContainsPoint(self.bounds, [touch locationInView:self])){
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
    if(!CGRectContainsPoint(self.bounds, [touch locationInView:self])){
//        self.label.textColor = [UIColor whiteColor];
//        self.arrow.tintColor = nil;
    } else {
//        self.label.tintColor = [UIColor redColor];
    }
    
    self.label.textColor = [UIColor whiteColor];
   self.arrow.highlighted = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.label.textColor = [UIColor whiteColor];
    self.arrow.highlighted = NO;
}
@end
