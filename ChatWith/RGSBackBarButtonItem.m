//
//  RGSBackBarButtonItem.m
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBackBarButtonItem.h"
#import "UIImage+Resize.h"

@implementation RGSBackBarButtonItem
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
    self.image = [[UIImage imageNamed:@"backArrow"] resizedImage:CGSizeMake(12, 25)];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(2, -2, 2, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 2, 0);
}

@end
