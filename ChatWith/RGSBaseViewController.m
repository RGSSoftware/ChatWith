//
//  RGSBaseViewController.m
//  ChatWith
//
//  Created by PC on 11/6/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"

#import "RGSSideMenuViewController.h"

@interface RGSBaseViewController ()
@property (nonatomic, strong)RGSSideMenuViewController *sideViewController;
@end

@implementation RGSBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
 
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
    
    self.menuBarButton = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"MenuIcon"] resizedImage:CGSizeMake(25, 17)] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController pushViewController:[RGSSideMenuViewController shared] animated:YES];
    }];
    
    self.menuBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.menuBarButton;

}

-(RGSSideMenuViewController *)sideViewController{
    if (_sideViewController == nil) {
        RGSSideMenuViewController *vc = [RGSSideMenuViewController new];
        vc.view.backgroundColor = [UIColor redColor];
        _sideViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSSideMenuViewController"];
 
    }
    
    return _sideViewController;
    }



@end
