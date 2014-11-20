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
    
    
    self.backgroundColor = [UIColor blackColor];
    
    self.messageTextView.enablesNewlineCharacter = YES;
    
    
    self.backGroundStartFrame = self.backGroundView.frame;
    
    //passing backGorundView because if i passed self to grow the backGround it will also move growingTextView
    //sendButton and anything that a direct subView of self, therefore I make a backGroundView that will grow
    self.messageTextView.growAnimationWithLinkingView = self.backGroundView;
    
    //passing self to messageTextView so it can communication back the grown hitDection area.
    //The area the growingTextView Makes
    self.messageTextView.messageComposerView = self;
    
    
    self.messageTextView.placeholderLabel.text = @"Chat With Friends...";
    self.backgroundColor = [UIColor clearColor];
    
    self.messageTextView.layer.cornerRadius = 10;
    self.messageTextView.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:0];
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.borderColor = [[UIColor colorWithWhite:0.343 alpha:1.000] CGColor];
    
    self.backGroundView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.90];
    
    self.messageTextView.internalTextView.textColor = [UIColor whiteColor];
    
    self.sendMessagebButton.tintColor = [UIColor colorWithHexString:@"57d6ff"];
    self.messageTextView.internalTextView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.messageTextView.delegate = self;
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
- (void)growingTextView:(CSGrowingTextView *)growingTextView didChangeHeight:(CGFloat)height{
    
}
-(void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height{
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
