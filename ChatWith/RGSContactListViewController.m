//
//  RGSContactListViewController.m
//  ChatWith
//
//  Created by PC on 10/22/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSContactListViewController.h"

#import "RGSContactCell.h"

#import "RGSManagedUser.h"
#import "RGSContact.h"

#import "RGSMessageListViewController.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

#import "LocalStorageService.h"
@interface RGSContactListViewController ()

@end

@implementation RGSContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.navigationItem.title = @"Select Contact";
    [self.navigationController.navigationBar
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor colorWithHexString:@"57d6ff"] ,NSForegroundColorAttributeName,
                             [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSFontAttributeName, nil]];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toChatListScreen:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 20, 80, 32)];
    
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor]
                 forState:UIControlStateHighlighted];
    button.titleEdgeInsets = UIEdgeInsetsMake(2, -20, 2, 0);
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    UIImage *image = [UIImage imageNamed:@"backButton"];
    [button setImage:[image resizedImage:CGSizeMake(20, 20)]
            forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 2, 0);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barButton;

    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MenuIcon"] resizedImage:CGSizeMake(25, 17)]
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    menuBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
}

-(void)toChatListScreen:(id)sender{
    //toChats
     [self performSegueWithIdentifier:@"toChats" sender:self];
//    [self.navigationController popViewControllerAnimated:NO];
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
    } else if ([segue.identifier isEqualToString:@"toChats"]){
    }
//
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

@end
