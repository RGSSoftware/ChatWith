//
//  RGSContactCell.m
//  ChatWith
//
//  Created by PC on 10/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactCell.h"

@implementation RGSContactCell

-(void)configurePresentation{
    self.thumbnailImageView.layer.masksToBounds = YES;
    //prevent every frame from requiring a re-mask on all the pixels
    //http://stackoverflow.com/questions/4314640/setting-corner-radius-on-uiimageview-not-working#4314683
    self.thumbnailImageView.layer.shouldRasterize = YES;
    [self.thumbnailImageView.layer setCornerRadius:10];
    
    [self.imageHighlightView.layer setCornerRadius:10];
    [self.contentView bringSubviewToFront:self.imageHighlightView];
}

-(void)highlight{
    self.imageHighlightView.hidden = NO;
    self.imageHighlightView.backgroundColor = [UIColor redColor];
}

-(void)deHighlight{
    self.imageHighlightView.hidden = YES;
}

@end
