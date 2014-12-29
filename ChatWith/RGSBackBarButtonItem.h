//
//  RGSBackBarButtonItem.h
//  ChatWith
//
//  Created by PC on 12/29/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSBackBarButtonItem : UIBarButtonItem

-(void)addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)controlEvent;

-(void)setTitle:(NSString *)title;

-(void)bar;

@end
