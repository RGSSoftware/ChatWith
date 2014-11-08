//
//  RGSMessageListViewController.m
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewController.h"

#import "RGSManagedUser.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

@implementation RGSMessageListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.receiver){
        self.navigationItem.title = self.receiver.fullName;
    }
    
//    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
//    self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
     UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toChatListScreen:)
     forControlEvents:UIControlEventTouchUpInside];
     [button setFrame:CGRectMake(0, 20, 80, 32)];
     
     [button setTitle:@"Chats" forState:UIControlStateNormal];
     [button setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
     [button setTitleColor:[UIColor lightGrayColor]
                  forState:UIControlStateHighlighted];
     button.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 2, 0);
     button.titleLabel.textAlignment = NSTextAlignmentLeft;
     button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
     
     UIImage *image = [UIImage imageNamed:@"backButton"];
     [button setImage:[image resizedImage:CGSizeMake(20, 20)]
             forState:UIControlStateNormal];
     
     button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 2, 30);
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
     
     self.navigationItem.leftBarButtonItem = barButton;
    
}

-(void)toChatListScreen:(id)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]- 3)] animated:NO];
}


//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    
//
//}

@end