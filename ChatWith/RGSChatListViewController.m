//
//  RGSConverstationTableViewController.m
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatListViewController.h"

#import "RGSMessageListViewController.h"

#import "RGSChat.h"
#import "RGSMessage.h"
#import "RGSContact.h"
#import "RGSManagedUser.h"

#import "RGSChatCell.h"

#import "LocalStorageService.h"

#import "UIImage+Resize.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+RGSinitWithColor.h"
#import "NSDate+Utilities.h"
#import "UINavigationController+RGSBlock.h"

#import "RGSBaseViewController+RGSSeparatorExtender.h"


@interface RGSChatListViewController ()

@property (nonatomic, strong)RGSChat *showChat;

@end

@implementation RGSChatListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                      }];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Chats";
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add"] resizedImage:CGSizeMake(20, 20)]
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(toContacts:)];
    addBarButton.tintColor = [UIColor colorWithHexString:@"46ABCC"];
    self.navigationItem.leftBarButtonItem = addBarButton;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

-(void)toContacts:(id)sender{
    [self performSegueWithIdentifier:@"toContacts" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    int rowCount = [sectionInfo numberOfObjects];
    return rowCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 140;
    }
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGSChatCell *cell;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"longerChatCell" forIndexPath:indexPath];
        
        UIView *conView = [[UIView alloc] initWithFrame:cell.frame];
        conView.backgroundColor = [UIColor clearColor];
        [conView addSubview:[cell customSelectedBackgroundViewWithFrame:CGRectMake(0, 65, 320, 75)]];
        cell.selectedBackgroundView = conView;

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
        cell.selectedBackgroundView = [cell customSelectedBackgroundViewWithFrame:cell.frame];
    }
    
    
    RGSChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.lastestMessageDate.text = chat.lastMessageDate.description;
    
    if ([chat.lastMessageDate isEarlierThanDate:[NSDate date]]) {
        if ([chat.lastMessageDate isToday]) {
            static NSDateFormatter *todayDateFormatter = nil;
            if (todayDateFormatter == nil) {
                todayDateFormatter = [NSDateFormatter new];
                todayDateFormatter.dateFormat = @"h:mm a";
            }
            cell.lastestMessageDate.text = [todayDateFormatter stringFromDate:chat.lastMessageDate];
        } else if ([chat.lastMessageDate isYesterday]){
            cell.lastestMessageDate.text = @"Yesterday";
            
        } else if ([chat.lastMessageDate isSameWeekAsDate:[NSDate date]]){
            static NSDateFormatter *sameweekDateFormatter = nil;
            if (sameweekDateFormatter == nil) {
                sameweekDateFormatter = [NSDateFormatter new];
                sameweekDateFormatter.locale = [NSLocale currentLocale];
                sameweekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]];
            }
            cell.lastestMessageDate.text = [sameweekDateFormatter stringFromDate:chat.lastMessageDate];
        } else {
            //Earlier than one week
            static NSDateFormatter *earlierWeekDateFormatter = nil;
            if (earlierWeekDateFormatter == nil) {
                earlierWeekDateFormatter = [NSDateFormatter new];
                earlierWeekDateFormatter.locale = [NSLocale currentLocale];
                earlierWeekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Mdy" options:0 locale:[NSLocale currentLocale]];
            }
            cell.lastestMessageDate.text = [earlierWeekDateFormatter stringFromDate:chat.lastMessageDate];
        }
    }
    
    cell.lastestMessageBody.text = ((RGSMessage *)[chat.messages anyObject]).body;
    cell.receiverName.text = chat.receiver.fullName;
    
    cell.receiverImage.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.731 alpha:1.000]];
    cell.receiverImage.layer.masksToBounds = YES;
    //prevent every frame from requiring a re-mask on all the pixels
    //http://stackoverflow.com/questions/4314640/setting-corner-radius-on-uiimageview-not-working#4314683
    cell.receiverImage.layer.shouldRasterize = YES;
    [cell.receiverImage.layer setCornerRadius:10];
    
    // Configure the cell...
    
    return cell;
}

//ios8 introduces the layoutmargins property on cells and table views
// therefore, to remove the cell separator leading spacing
//You'll need to set both of them to UIEdgeInsetsZero
//http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working#25877725
//Part-1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fullyExtendTableViewCellSeparator:cell];
}
//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self fullyExtendTableViewSeparator:self.tableView];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[RGSMessageListViewController class]]){
        RGSMessageListViewController *messageListViewController = (RGSMessageListViewController
                                                                   *)[segue destinationViewController];
        if (self.showChat) {
            messageListViewController.chat = self.showChat;
        } else {
            messageListViewController.chat = [_fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        }
        
    } else if ([segue.destinationViewController isKindOfClass:[RGSContactListViewController class]]){
        RGSContactListViewController *contactListViewController = (RGSContactListViewController
                                                                   *)[segue destinationViewController];
        contactListViewController.delegate = self;
    }
}

-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContact:(RGSContact *)contact{

    [self.navigationController popViewControllerAnimated:YES completion:^{
        NSPredicate *chatPredicate = [NSPredicate predicateWithFormat:@"(%@ IN %K) AND (%@ IN %K)", [[LocalStorageService shared] savedUser], @"participants", contact.friend, @"participants"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[RGSChat MR_entityDescription]];
        [fetchRequest setPredicate:chatPredicate];
        
        NSError *error;
        NSArray *result = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        if (!result.count == 0) {
            self.showChat = [result firstObject];
            [self bk_performBlock:^(id obj) {
                [self performSegueWithIdentifier:@"toMessages" sender:self];
            } afterDelay:0];
            
            
        } else {
            
        };
    }];
}

-(NSFetchedResultsController *)fetchedResultsController{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[RGSChat MR_entityDescription]];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"lastMessageDate" ascending:NO]]];
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%@ IN %K", [[LocalStorageService shared] savedUser], @"participants"]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.showChat = nil;
    [self deregisterForNSManagedObjectNotifications];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}
-(void)dealloc{
    [self deregisterForNSManagedObjectNotifications];
}
- (void)deregisterForNSManagedObjectNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (IBAction)unwindToChatList:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
