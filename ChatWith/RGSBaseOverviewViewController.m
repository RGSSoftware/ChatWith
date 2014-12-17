//
//  RGSBaseOverviewViewController.m
//  ChatWith
//
//  Created by PC on 12/17/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseOverviewViewController.h"

@implementation RGSBaseOverviewViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tintView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tintView.backgroundColor = [UIColor blackColor];
    self.tintView.alpha = 0;
}
@end
