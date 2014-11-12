//
//  RGSMessageCell.m
//  ChatWith
//
//  Created by PC on 11/12/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageCell.h"

@implementation RGSMessageCell

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        _body = [[UILabel alloc] initWithFrame:CGRectZero];
        [_body setLineBreakMode:NSLineBreakByWordWrapping];
        [_body setMinimumScaleFactor:16];
        [_body setNumberOfLines:0];
        [_body setFont:[UIFont systemFontOfSize:16]];
        
//        [[_body layer] setBorderWidth:2.0f];
        
        [self.contentView addSubview:_body];
    }
    return self;
}

@end
