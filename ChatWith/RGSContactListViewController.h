//
//  RGSContactListViewController.h
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSBaseViewController.h"

@class RGSContact;

@interface RGSContactListViewController : RGSBaseViewController <UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *InviteFriendsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) id delegate;

@end

@protocol RGSContactListViewControllerDelegate <NSObject>

-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContact:(RGSContact *)contact;
@end
