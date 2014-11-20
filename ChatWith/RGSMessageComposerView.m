//
//  RGSMessageComposerView.m
//  ChatWith
//
//  Created by PC on 11/16/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageComposerView.h"
#import "CSGrowingTextView.h"
#import "UIColor+RGSColorWithHexString.h"

@interface RGSMessageComposerView()

@property (nonatomic)CGRect backGroundStartFrame;
@property(nonatomic)CGRect hitRect;

@end

@implementation RGSMessageComposerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        
    }
    return self;
}
-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.backGroundStartFrame = self.backGroundView.frame;
    self.messageTextView.enablesNewlineCharacter = YES;
    self.messageTextView.placeholderLabel.text = @"Chat With Friends...";
    self.messageTextView.layer.cornerRadius = 10;
    self.messageTextView.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:0];
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.borderColor = [[UIColor colorWithWhite:0.343 alpha:1.000] CGColor];
    self.messageTextView.delegate = self;
    
    self.messageTextView.internalTextView.textColor = [UIColor whiteColor];
    self.messageTextView.internalTextView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.backGroundView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.90];
    
    self.sendMessagebButton.tintColor = [UIColor colorWithHexString:@"57d6ff"];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    CGRect touchRect = CGRectInset(self.bounds, 0, self.hitRect.origin.y);
    if (CGRectContainsPoint(touchRect, point)) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}

-(void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height{
    CGRect tempRect = CGRectZero;
    tempRect.size = CGSizeMake(CGRectGetWidth(self.frame), height + 9);
    tempRect.origin = CGPointMake(0, (CGRectGetMaxY(self.backGroundStartFrame) - (height)) - 8);
    self.hitRect = tempRect;

    
    [UIView animateWithDuration:self.messageTextView.growAnimationDuration delay:0.0
                        options:self.messageTextView.growAnimationOptions
                     animations:^{

    self.backGroundView.frame = CGRectMake(0,
                                           (CGRectGetMaxY(self.backGroundStartFrame) - (height)) - 8,
                                           CGRectGetWidth(self.backGroundView.frame),
                                           height + 9);
                     } completion:nil];
}
@end
