//
//  RGSSideMenuViewController.h
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RGSBaseViewController.h"

@interface RGSSideMenuViewController : RGSBaseViewController

@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UITableView *buttonsTableView;
@end
