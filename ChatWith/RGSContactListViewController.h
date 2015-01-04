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
@class RGSContactCell;
@class RGSContactListViewController;
@class RGSSearchBar;

@protocol RGSContactListViewControllerDelegate <NSObject>

@optional
-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContact:(RGSContact *)contact;
-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContactAtIndex:(NSIndexPath *)contactIndex;
@end

@interface RGSContactListViewController : RGSBaseViewController <UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet RGSSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *InviteFriendsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchFilterSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) IBOutlet id <RGSContactListViewControllerDelegate> delegate;

@property BOOL showLeftBarButtonItem;

-(RGSContactCell *)contactCellAtIndex:(NSIndexPath *)contactCellIndex;
-(RGSContact *)contactAtIndex:(NSIndexPath *)contactIndex;

@end


