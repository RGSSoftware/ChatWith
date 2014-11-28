//
//  RGSPpopSegue.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPopSegue.h"
#import "RGSBaseViewController.h"

@implementation RGSPopSegue
-(void)perform{
    [self.fromViewController.navigationController popToViewController:self.toViewController animated:YES];
}

@end
