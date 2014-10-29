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
#import "UIImage+Resize.h"
#import "RGSContactCell.h"

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
    [self.searchBar setImage:[UIImage imageNamed:@"SearchClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
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
    
    CALayer *maskLayer = [CALayer new];
    maskLayer.frame = self.contactsView.bounds;
    self.contactsView.layer.mask = maskLayer;
    
    //http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
    //    creating gradient as mask layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //an array of colors that dictatates the gradient(s)
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor];
    //these are percentage points along the line defined by our startPoint and endPoint and correspond to our colors array. The gradient will shift between the colors between these percentage points.
    gradientLayer.locations = @[@0.0, @0.18, @1.0f];
    gradientLayer.frame = CGRectMake(CGRectGetMinX(self.contactsView.bounds),
                                     CGRectGetMinY(self.contactsView.bounds),
                                     CGRectGetWidth(self.contactsView.bounds)-10,
                                     CGRectGetHeight(self.contactsView.bounds));
    [maskLayer addSublayer:gradientLayer];
    
    CALayer *whitelayer = [CALayer new];
    whitelayer.frame = CGRectMake(CGRectGetWidth(self.contactsView.bounds)-10,
                                  CGRectGetMinY(self.contactsView.bounds),
                                  10,
                                  CGRectGetHeight(self.contactsView.bounds));
    whitelayer.backgroundColor = [UIColor whiteColor].CGColor;
    [maskLayer addSublayer:whitelayer];
    
    
    self.InviteFriendsButton.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
    [self.InviteFriendsButton.layer setCornerRadius:10];
    [self.InviteFriendsButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.InviteFriendsButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view bringSubviewToFront:self.InviteFriendsButton];
    
    self.navigationItem.title = @"Select Contact";
    [self.navigationController.navigationBar
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor colorWithHexString:@"57d6ff"] ,NSForegroundColorAttributeName,
                             [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add"] resizedImage:CGSizeMake(20, 20)]
                                                                  style:UIBarButtonItemStylePlain target:nil action:nil];
    addBarButton.tintColor = [UIColor colorWithHexString:@"46ABCC"];
    self.navigationItem.leftBarButtonItem = addBarButton;
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MenuIcon"] resizedImage:CGSizeMake(25, 17)]
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    menuBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = menuBarButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 60;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RGSContactCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.thumbnailImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.731 alpha:1.000]];
    cell.thumbnailImageView.layer.masksToBounds = YES;
    cell.thumbnailImageView.layer.shouldRasterize = YES;
    [cell.thumbnailImageView.layer setCornerRadius:10];
    
    cell.nameLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 2
    CGSize retval;
    retval.height = 80;
    retval.width = 60;
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(64, 16, 5, 16);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 16;
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
