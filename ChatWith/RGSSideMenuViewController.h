//
//  RGSSideMenuViewController.h
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RGSBaseViewController.h"

@interface RGSSideMenuViewController : RGSBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UIView *closeTapView;
@property (weak, nonatomic) IBOutlet UITableView *buttonsTableView;

@property (weak, nonatomic) UIView *subFromView;

@property (weak, nonatomic) UIView *outLineView;
@property (weak, nonatomic) UIView *tintView;
@end
