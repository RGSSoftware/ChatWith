//
//  RGSContactListViewController.h
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSContactListViewController : UIViewController <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *InviteFriendsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;

@end
