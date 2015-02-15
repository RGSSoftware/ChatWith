//
//  RGSButton.h
//  ChatWith
//
//  Created by PC on 2/13/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSButton : UIButton

@property(nonatomic) IBOutlet UILabel *label;
@property(nonatomic) IBOutlet UIImageView *image;

@property(nonatomic)CGRect touchRect;

@property (nonatomic, strong) void(^touchUpInsideHandle)(id sender);

-(instancetype)initWithHandler:(void (^)(id sender))action;



@end
