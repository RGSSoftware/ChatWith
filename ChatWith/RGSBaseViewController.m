//
//  RGSBaseViewController.m
//  ChatWith
//
//  Created by PC on 11/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"

@implementation RGSBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.frame = self.view.bounds;
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
}

@end
