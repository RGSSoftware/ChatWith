//
//  RGSContactListViewController.m
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactListViewController.h"
#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"

@interface RGSContactListViewController ()

@end

@implementation RGSContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage imageWithColor:
                                      [UIColor colorWithHexString:@"414141" alpha:.16]];
    
    [self.searchBar setImage:[UIImage imageNamed:@"SearchMagnifyingGlassIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setPlaceholder:@"Search                                                  "];
    
    for (UIView *subview in _searchBar.subviews) {
        for (UIView *subSubview in subview.subviews) {
            if ([subSubview isKindOfClass:[UITextField class]]) {
                UITextField *searchField = (UITextField *)subSubview;
                searchField.backgroundColor = [UIColor clearColor];
                searchField.textColor = [UIColor whiteColor];
                break;
            }
        }
    }
    
//    SearchMagnifyingGlassIcon
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
