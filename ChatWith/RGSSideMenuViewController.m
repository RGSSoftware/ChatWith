//
//  RGSSideMenuViewController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSideMenuViewController.h"
@implementation RGSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(closeMenu:);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.closeTapView bk_whenTapped:^{
        [self closeMenu:nil];
    }];
}

#pragma mark - UITableViewDataSource ()
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
#pragma mark - UITableViewDelegate ()
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.backgroundColor = [UIColor cyanColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor orangeColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return cell;
}
-(void)closeMenu:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
