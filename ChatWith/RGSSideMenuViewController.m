//
//  RGSSideMenuViewController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSideMenuViewController.h"
#import "UIColor+RGSColorWithHexString.h"

#import "RGSSideMenuCell.h"

#import "RGSBaseViewController+RGSSeparatorExtender.h"

#import "UIButton+RGSUIBackButton.h"
#import "UIImage+Resize.h"
@implementation RGSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(closeMenu:);
    
    self.buttonsTableView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    self.buttonsTableView.scrollEnabled = NO;
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 220, 40)];
    
    [backButton setTitleColor:[UIColor colorWithHexString:@"57d6ff"]
                 forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor]
                 forState:UIControlStateHighlighted];
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImage *image = [UIImage imageNamed:@"terminator"];
    [backButton setImage:[image resizedImage:CGSizeMake(40, 40)]
            forState:UIControlStateNormal];
    backButton.imageView.layer.cornerRadius = 10;
    
    [backButton addTarget:nil action:nil
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Terminator" forState:UIControlStateNormal];
    backButton.titleLeftEdgeInset = 10;
    backButton.imageLeftEdgeInset = 0;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barButton;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.closeTapView bk_whenTapped:^{
        [self closeMenu:nil];
    }];
}

#pragma mark - UITableViewDataSource ()
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fullyExtendTableViewCellSeparator:cell];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


#pragma mark - UITableViewDelegate ()
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RGSSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.icon.image = [UIImage imageNamed:@"chats_offwhite"];
            cell.iconSelected.image = [UIImage imageNamed:@"chats"];
            cell.menuLabel.text = @"Chats";
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed:@"friends_offwhite"];
            cell.iconSelected.image = [UIImage imageNamed:@"friends"];
            cell.menuLabel.text = @"Friends";
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed:@"setting_offwhite"];
            cell.iconSelected.image = [UIImage imageNamed:@"setting"];
            cell.menuLabel.text = @"Settings";
            break;
        default:
            break;
    }
    return cell;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self fullyExtendTableViewSeparator:self.buttonsTableView];
}

-(void)closeMenu:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
