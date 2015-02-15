//
//  RGSButton.m
//  ChatWith
//
//  Created by PC on 2/13/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSButton.h"
const float highlight = .1;
const float deHighlight  = .3;

@interface RGSButton ()
@end

@implementation RGSButton


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _touchRect = CGRectNull;
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        
        _touchRect = CGRectNull;
        
        _image = [[UIImageView alloc] init];
        _image.frame = CGRectZero;
        [self addSubview:_image];
        
        _label = [UILabel labelWithText:@""];
        _label.frame = CGRectZero;
        _label.highlightedTextColor =  [UIColor lightGrayColor];
        [self addSubview:_label];
        
        
    }
    return self;
}


//-(void)setImage:(UIImageView *)image{
//    _image = image;
//    [self addSubview:_image];
//}
//
//-(void)setLabel:(UILabel *)label{
//    _label = label;
//    [self addSubview:_label];
//}
-(void)awakeFromNib{
     self.label.highlightedTextColor = [UIColor lightGrayColor];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
//    CGRect rect = [self convertRect:self.frame toView:nil];
//    rect.origin.x = 0;
////    rect.origin.y = 20;
//    rect.size.width = rect.size.width + 16;
    CGRect rect = !CGRectIsNull(self.touchRect) ? self.touchRect : self.frame;
    if(CGRectContainsPoint(rect, [touch locationInView:self.superview])){
        [UIView transitionWithView:self
                          duration:highlight
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image.highlighted = YES;
                            self.label.highlighted = YES;
                            self.highlighted = YES;
                        }
                        completion:nil];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
//    CGRect rect = [self convertRect:self.frame toView:nil];
//    rect.origin.x = 0;
////    rect.origin.y = 20;
//    rect.size.width = rect.size.width + 16;
    CGRect rect = !CGRectIsNull(self.touchRect) ? self.touchRect : self.frame;
    if(CGRectContainsPoint(rect, [touch locationInView:self.superview])){
        if(!self.image.highlighted){
        [UIView transitionWithView:self
                          duration:highlight
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image.highlighted = YES;
                            self.label.highlighted = YES;
                            self.highlighted = YES;
                        }
                        completion:nil];
        }
    } else {
        if(self.image.highlighted){
        [UIView transitionWithView:self
                          duration:deHighlight
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.image.highlighted = NO;
                            self.label.highlighted = NO;
                            self.highlighted = NO;
                        }
                        completion:nil];
         }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [UIView transitionWithView:self
                      duration:deHighlight
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.image.highlighted = NO;
                        self.label.highlighted = NO;
                        self.highlighted = NO;
                    }
                    completion:nil];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [UIView transitionWithView:self
                      duration:deHighlight
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.image.highlighted = NO;
                        self.label.highlighted = NO;
                        self.highlighted = NO;
                    }
                    completion:nil];
}




@end
