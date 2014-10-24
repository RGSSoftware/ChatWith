//
//  RGSContactListViewController.m
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactListViewController.h"
#import "UIImage+RGSinitWithColor.h"

@interface RGSContactListViewController ()

@end

@implementation RGSContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *searchView = [UIView new];
    searchView.frame = CGRectMake(0, 65, CGRectGetWidth(self.view.frame), 40);
    searchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.16];
    
    //create background images for the navigation bar
    UIImage *gradientImage44 = [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1]]; //replace "nil" with your method to programmatically create a UIImage object with transparent colors for portrait orientation
//    UIImage *gradientImage32 = nil; //replace "nil" with your method to programmatically create a UIImage object with transparent colors for landscape orientation
    
    //customize the appearance of UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:searchView];
    
//    [self.navigationController.navigationBar setBarTintColor:[self getUIColorObjectFromHexString:@"6c6c6c" alpha:1]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.1]];
//    self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
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
