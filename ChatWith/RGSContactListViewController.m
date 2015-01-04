//
//  RGSContactListViewController.m
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactListViewController.h"

#import "RGSMessageListViewController.h"

#import "RGSManagedUser.h"
#import "RGSContact.h"

#import "RGSContactCell.h"

#import "LocalStorageService.h"

#import "UIImage+Resize.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+RGSinitWithColor.h"
#import "UIImage+Resize.h"

#import "NSAttributedString+RGSExtras.h"


#import "RGSShowOverviewAnimatonController.h"

#import "RGSSearchBar.h"
#import "RGSBackBarButtonItem.h"
#import "RGSTitleBarButtonItem.h"

#import "RGSContactDetailHandler.h"
@interface RGSContactListViewController ()

@property (nonatomic, strong)RGSShowOverviewAnimatonController *overviewAnimationController;
@property UIView *dimView;

@property RGSBackBarButtonItem *barBarButtonItem;

@property(nonatomic)RGSContactDetailHandler *contactDetailHandler;

@end

@implementation RGSContactListViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _contactDetailHandler = [RGSContactDetailHandler new];
        _delegate = _contactDetailHandler;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Contacts";
    
    CALayer *maskLayer = [CALayer new];
    maskLayer.frame = self.contactsView.bounds;
    self.contactsView.layer.mask = maskLayer;
    
    //http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
    //creating gradient as mask layer
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
    
    if(self.showLeftBarButtonItem){
        
        self.barBarButtonItem = [RGSBackBarButtonItem new];
        [self.barBarButtonItem addTarget:self action:@selector(toChatListScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.barBarButtonItem setTitle:@"Cancel"];
        self.navigationItem.leftBarButtonItem = self.barBarButtonItem;
        
        self.navigationItem.title = @"Select Contact";
    } else{
        
        self.barBarButtonItem = [RGSBackBarButtonItem new];
        [self.barBarButtonItem addTarget:self action:@selector(toChatListScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.barBarButtonItem setTitle:@"Cancel"];
        self.navigationItem.leftBarButtonItem = self.barBarButtonItem;
    }

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    self.overviewAnimationController = [RGSShowOverviewAnimatonController new];
    
    [self.searchBar bk_addObserverForKeyPath:@"isFirstResponder" task:^(id target) {
        
    }];
    
//    self.InviteFriendsButton.alpha = 0;
    
    self.searchFilterSegmentedControl.alpha = 0;
    self.searchFilterSegmentedControl.tintColor = [UIColor colorWithHexString:@"414141" alpha:.75];
    [self.searchFilterSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [self.searchFilterSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"414141"]} forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.searchFilterSegmentedControl];
}

-(void)toChatListScreen:(id)sender{
    //toChats
     [self performSegueWithIdentifier:@"fromContactToChatListSegue" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [[_fetchedResultsController sections] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RGSContactCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ContactCell" forIndexPath:indexPath];
    [cell configurePresentation];
    
    RGSContact *contact = [_fetchedResultsController objectAtIndexPath:indexPath];
    //imp temp user.image
    if(contact.friend.imageData){
        cell.thumbnailImageView.image = [UIImage imageWithData:contact.friend.imageData];
    } else {
        cell.thumbnailImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.731 alpha:1.000]];
    }
    
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.nameLabel.text = contact.friend.fullName;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [((RGSContactCell *)[collectionView cellForItemAtIndexPath:indexPath]) highlight];
}

- (void)collectionView:(UICollectionView *)collectionView
didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [((RGSContactCell *)[collectionView cellForItemAtIndexPath:indexPath]) deHighlight];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize retval;
    retval.height = 80;
    retval.width = 60;
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(64, 16, 5, 16);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 16;
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation\
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toMessagesScreen"]){
        RGSContactCell *contactCell = (RGSContactCell *)sender;
        RGSContact *contact = [_fetchedResultsController objectAtIndexPath:[self.collectionView indexPathForCell:contactCell]];
        
        RGSMessageListViewController *messageListViewController = (RGSMessageListViewController
                                                                   *)[segue destinationViewController];
        messageListViewController.receiver = contact.friend;
    } else if ([segue.identifier isEqualToString:@"toInviteScreen"]){
        UIViewController *toVC = [segue destinationViewController];
//        toVC.transitioningDelegate = [self overviewAnimationController];
    }
//
}
-(RGSContactCell *)contactCellAtIndex:(NSIndexPath *)contactCellIndex{
    return (RGSContactCell *)[self.collectionView cellForItemAtIndexPath:contactCellIndex];
}
-(RGSContact *)contactAtIndex:(NSIndexPath *)contactIndex{
    return [_fetchedResultsController objectAtIndexPath:contactIndex];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(contactListViewController:didSelectContactAtIndex:)]){
        [self.delegate contactListViewController:self didSelectContactAtIndex:indexPath];
    }
    
    if ([self.delegate respondsToSelector:@selector(contactListViewController:didSelectContact:)]) {
        
        RGSContact *contact = [_fetchedResultsController objectAtIndexPath:indexPath];
        [self.delegate contactListViewController:self didSelectContact:contact];
    }
}


-(NSFetchedResultsController *)fetchedResultsController{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[RGSContact MR_entityDescription]];

    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"friend.fullName" ascending:YES]]];
    [fetchRequest setFetchBatchSize:25];

    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"source.currentUser", [NSNumber numberWithBool:YES]]];
        
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)searchBarTextDidBeginEditing:(RGSSearchBar *)searchBar{

    self.navigationItem.title = @"Search";
    
    [self addDimViewTo:self.view];
    
    [searchBar selectState];
    
    [UIView animateWithDuration:.4 animations:^{
        self.dimView.alpha = .08;
        self.InviteFriendsButton.alpha = 0;
        self.searchFilterSegmentedControl.alpha = 1;
    }];

    RGSTitleBarButtonItem *cancelBarButtonItem = [[RGSTitleBarButtonItem alloc] initWithTitle:@"Cancel" handler:^(id sender) {
        searchBar.text = nil;
        
        [searchBar resignFirstResponder];
        
    }];
    cancelBarButtonItem.titleColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    
    RGSTitleBarButtonItem *doneBarButtonItem = [[RGSTitleBarButtonItem alloc] initWithTitle:@"Done" handler:^(id sender) {
        [searchBar resignFirstResponder];
    }];
    doneBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    
}
- (void)searchBarTextDidEndEditing:(RGSSearchBar *)searchBar{
    
    self.navigationItem.title = @"Contacts";
    
    [searchBar deSelect];
    
    [UIView animateWithDuration:.3
                     animations:^{
                         self.InviteFriendsButton.alpha = 1;
                         self.searchFilterSegmentedControl.alpha = 0;
                         self.dimView.alpha = 0;
                     } completion:^(BOOL finished) {
                         if(finished) [self.dimView removeFromSuperview];
                     }];
    
    
    if(self.barBarButtonItem){
        self.navigationItem.leftBarButtonItem = self.barBarButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.navigationItem.rightBarButtonItem = self.menuBarButton;
}


- (void)addDimViewTo:(UIView *)view {
    CGRect dimViewRect = view.frame;
    dimViewRect.size.height = CGRectGetHeight(view.frame) - 65;
    dimViewRect.origin.y = 64;
    
    self.dimView = [[UIView alloc] initWithFrame:dimViewRect];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = 0;
    [view addSubview:self.dimView];
    [view sendSubviewToBack:self.dimView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}


@end
