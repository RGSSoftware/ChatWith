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
@implementation RGSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(closeMenu:);
    
    self.buttonsTableView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    self.buttonsTableView.scrollEnabled = NO;
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
    
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    cell.selectedBackgroundView = view;
    
    cell.menuLabel.textColor = [UIColor colorWithWhite:0.901 alpha:1.000];
    
    switch (indexPath.row) {
        case 0:
            cell.icon.image = [UIImage imageNamed:@"chats_offwhite"];
            cell.menuLabel.text = @"Chats";
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed:@"friends_offwhite"];
            cell.menuLabel.text = @"Friends";
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed:@"setting_offwhite"];
            cell.menuLabel.text = @"Chats";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RGSSideMenuCell *cell = (RGSSideMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.icon.image = [UIImage imageNamed:@"chats"];
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed:@"friends"];
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed:@"setting"];
            break;
        default:
            break;
    }

    
    cell.menuLabel.textColor = [UIColor whiteColor];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    RGSSideMenuCell *cell = (RGSSideMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.icon.image = [UIImage imageNamed:@"chats_offwhite"];
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed:@"friends_offwhite"];
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed:@"setting_offwhite"];
            break;
        default:
            break;
    }

    cell.menuLabel.textColor = [UIColor colorWithWhite:0.901 alpha:1.000];
}
- (void)tableView:(UITableView *)tableView
didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
