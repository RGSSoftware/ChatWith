//
//  RGSSideMenuViewController.m
//  ChatWith
//
//  Created by PC on 12/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSideMenuViewController.h"

@interface RGSSideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RGSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
