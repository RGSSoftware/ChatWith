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

#import "RGSChatListViewController.h"
#import "RGSContactListViewController.h"
#import "RGSSettingViewController.h"

#import "RGSBaseViewController+RGSSeparatorExtender.h"

#import "UIButton+RGSUIBackButton.h"
#import "UIImage+Resize.h"

#import "UINavigationController+RGSBlock.h"
#import "RGSBaseViewController.h"
@implementation RGSSideMenuViewController

static RGSSideMenuViewController *_instance = nil;
static dispatch_once_t once_token = 0;

+ (instancetype)shared
{
    dispatch_once(&once_token, ^{
        if (_instance == nil) {
            _instance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSSideMenuViewController"];
        }
    });
    
    return _instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(closeMenu:);
    
    self.buttonsTableView.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    self.buttonsTableView.scrollEnabled = NO;
//    self.buttonsTableView.s
    
    
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
    
    UIViewController *rootViewController = self.navigationController.viewControllers[0];
    if([rootViewController isKindOfClass:[RGSChatListViewController class]]){
        [self.buttonsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else if ([rootViewController isKindOfClass:[RGSContactListViewController class]]){
        [self.buttonsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else if ([rootViewController isKindOfClass:[RGSSettingViewController class]]){
        [self.buttonsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *rootViewController = self.navigationController.viewControllers[0];
    if([rootViewController isEqual:self.navigationController.topViewController]){
        [self closeMenu:nil];
    }
    if(indexPath.row == 0){
       
        RGSBaseViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSChatListViewController"];
        
        [self.navigationController popViewControllerAnimated:YES withReplaceStack:@[vc]];

        
    } else if (indexPath.row == 1){
            RGSBaseViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSContactListViewController"];
            
            [self.navigationController popViewControllerAnimated:YES withReplaceStack:@[vc]];
    } else if (indexPath.row == 2){
//        RGSBaseViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSContactListViewController"];
//        
//        [self.navigationController popViewControllerAnimated:YES withReplaceStack:@[vc]];
    }
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
