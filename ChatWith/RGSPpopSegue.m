//
//  RGSPpopSegue.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPpopSegue.h"
#import "RGSBaseViewController.h"

@implementation RGSPpopSegue
-(void)perform{
    [self.fromViewController.navigationController popToViewController:self.toViewController animated:YES];
}

@end
