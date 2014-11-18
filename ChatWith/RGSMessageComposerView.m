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
    
    //passing the starting place of backGroundView because the growth animation will grow from this offset
    self.messageTextView.messageComposerStartingY = self.backGroundView.frame.origin.y;
    
    //passing backGorundView because if i passed self to grow the backGround it will also move growingTextView
    //sendButton and anything that a direct subView of self, therefore I make a backGroundView that will grow
    self.messageTextView.growAnimationWithLinkingView = self.backGroundView;
    
    //passing self to messageTextView so it can communication back the grown hitDection area.
    //The area the growingTextView Makes
    self.messageTextView.messageComposerView = self;
    
    
    self.messageTextView.placeholderLabel.text = @"Chat With Friends...";
    self.backgroundColor = [UIColor clearColor];
//    self.messageTextView.placeholderLabel.
    self.messageTextView.layer.cornerRadius = 10;
    self.messageTextView.backgroundColor = [UIColor colorWithHexString:@"414141"];
    self.backGroundView.backgroundColor = [UIColor colorWithHexString:@"363636"];
    self.messageTextView.internalTextView.textColor = [UIColor whiteColor];
    
    self.sendMessagebButton.tintColor = [UIColor colorWithHexString:@"57d6ff"];
    self.messageTextView.internalTextView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//    self.messageTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 5);

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
@end
