//
//  RGSBaseViewController.m
//  ChatWith
//
//  Created by PC on 11/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"

#import "UIImage+Resize.h"
#import "UIColor+RGSColorWithHexString.h"

#import "RGSSideMenuViewController.h"

@implementation RGSBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.frame = self.view.bounds;
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    self.backgroundView.hidden = YES;
    
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.frame = self.view.bounds;
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [mainWindow addSubview:view];
    [mainWindow sendSubviewToBack:view];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor colorWithHexString:@"57d6ff"] ,NSForegroundColorAttributeName,
                             [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSFontAttributeName, nil]];
    
//    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MenuIcon"] resizedImage:CGSizeMake(25, 17)]
//                                                                      style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"MenuIcon"] resizedImage:CGSizeMake(25, 17)] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController pushViewController:[self sideViewController] animated:YES];
    }];
    
    menuBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = menuBarButton;

}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
}

-(RGSSideMenuViewController *)sideViewController{
    RGSSideMenuViewController *vc = [RGSSideMenuViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSSideMenuViewController"];
}



@end
