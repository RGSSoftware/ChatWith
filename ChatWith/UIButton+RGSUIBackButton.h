//
//  UIButton+RGSUIBackButton.h
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RGSUIBackButton)

@property (nonatomic)CGFloat titleLeftEdgeInset;
@property (nonatomic)CGFloat imageLeftEdgeInset;

+(UIButton *)buttonAsCustomBackButton;

@end
