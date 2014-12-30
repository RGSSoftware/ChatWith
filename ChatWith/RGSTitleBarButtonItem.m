//
//  RGSTitleBarButtonItem.m
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSTitleBarButtonItem.h"

@implementation RGSTitleBarButtonItem

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action{
    self = [super initWithTitle:title handler:action];
    if (self) {
        [self subInit];
    }
    return self;
    
}

-(instancetype)initWithHandler:(void (^)(id))action{
    self = [super initWithHandler:action];
    if (self) {
        [self subInit];
    }
    return self;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self subInit];
    }
    return self;
}

-(void)subInit{
    self.titleEdgeInsets = UIEdgeInsetsMake(2, -5, 2, 0);
    
    
}

-(void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment{
    if(contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft){
       self.titleEdgeInsets = UIEdgeInsetsMake(2, -5, 2, 0);
    } else {
        self.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 2, -3);
    }
    
    super.contentHorizontalAlignment = contentHorizontalAlignment;
}



@end
