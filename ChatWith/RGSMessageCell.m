//
//  RGSMessageCell.m
//  ChatWith
//
//  Created by PC on 11/12/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageCell.h"

@implementation RGSMessageCell

-(void)awakeFromNib{
    self.body.lineBreakMode = NSLineBreakByWordWrapping;
//    self.body.minimumScaleFactor = 16;
    self.body.numberOfLines = 0;
    self.clipsToBounds = NO;
    
    self.bodyImageView.layer.cornerRadius = 10;
    self.bodyImageView.layer.masksToBounds = YES;
    self.bodyImageView.layer.shouldRasterize = YES;
    self.bodyImageView.hidden = NO;
    
}

@end
