//
//  RGSBackButtonContainer.h
//  ChatWith
//
//  Created by PC on 2/8/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSBackButtonContainer : UIView

@property UILabel *label;
@property UIImageView *arrow;

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(id sender))action;


@end
