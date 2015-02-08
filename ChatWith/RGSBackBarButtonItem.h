//
//  RGSBackBarButtonItem.h
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSBarButtonItem.h"

@interface RGSBackBarButtonItem : UIBarButtonItem
@property UILabel *label;
@property UIImageView *arrow;

@property(nonatomic)UIColor *titleColor;

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action;
-(instancetype)initWithHandler:(void (^)(id))action;

@end
