//
//  RGSBarButtonItem.h
//  ChatWith
//
//  Created by PC on 12/30/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSBarButtonItem : UIBarButtonItem

@property(nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;
@property(nonatomic) UIColor *textColor;
@property(nonatomic)UIEdgeInsets titleEdgeInsets;
@property(nonatomic)UIEdgeInsets imageEdgeInsets;


-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action;
-(instancetype)initWithHandler:(void (^)(id))action;

-(void)addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)controlEvent;
@end
