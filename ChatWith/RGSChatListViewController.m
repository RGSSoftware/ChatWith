//
//  RGSConverstationTableViewController.m
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatListViewController.h"

#import "RGSChatCell.h"

#import "RGSMessageListViewController.h"

#import "RGSChat.h"
#import "RGSMessage.h"
#import "RGSContact.h"
#import "RGSUser.h"

#import "LocalStorageService.h"

@interface RGSChatListViewController ()

@property (nonatomic, strong)RGSChat *showChat;

@end

@implementation RGSChatListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Chats";
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add"] resizedImage:CGSizeMake(20, 20)]
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(toContacts:)];
    addBarButton.tintColor = [UIColor colorWithHexString:@"46ABCC"];
    self.navigationItem.leftBarButtonItem = addBarButton;
    
   
    
    
//    self.view.layer.borderWidth = 2;
    self.tableView.contentInset = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
//    [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
//        [self.tableView reloadData];
//    } repeats:YES];

    
    
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
//    if (indexPath.row == 0) {
//        return 140;
//    }
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGSChatCell *chatCell;
    
//    if(indexPath.row == 0){
//        cell = [tableView dequeueReusableCellWithIdentifier:@"longerChatCell" forIndexPath:indexPath];
//        
//        UIView *conView = [[UIView alloc] initWithFrame:cell.frame];
//        conView.backgroundColor = [UIColor clearColor];
//        [conView addSubview:[cell customSelectedBackgroundViewWithFrame:CGRectMake(0, 65, 320, 75)]];
//        cell.selectedBackgroundView = conView;
//
//    } else {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
//        cell.selectedBackgroundView = [cell customSelectedBackgroundViewWithFrame:cell.frame];
//    }
    chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    chatCell.selectedBackgroundView = [chatCell customSelectedBackgroundViewWithFrame:chatCell.frame];
//    chatCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    RGSChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    chatCell.lastestMessageDate.text = chat.lastMessageDate.description;
    
    RGSMessage *lastestMessage = [[chat.messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]]] firstObject];
    NSDate *lastMessageDate = lastestMessage.date;

    
    if ([lastestMessage.date isEarlierThanDate:[NSDate date]]) {
        if ([lastestMessage.date isToday]) {
            static NSDateFormatter *todayDateFormatter = nil;
            if (todayDateFormatter == nil) {
                todayDateFormatter = [NSDateFormatter new];
                todayDateFormatter.dateFormat = @"h:mm a";
            }
            chatCell.lastestMessageDate.text = [todayDateFormatter stringFromDate:lastestMessage.date];
        } else if ([lastestMessage.date isYesterday]){
            chatCell.lastestMessageDate.text = @"Yesterday";
            
        } else if ([lastestMessage.date isSameWeekAsDate:[NSDate date]]){
            static NSDateFormatter *sameweekDateFormatter = nil;
            if (sameweekDateFormatter == nil) {
                sameweekDateFormatter = [NSDateFormatter new];
                sameweekDateFormatter.locale = [NSLocale currentLocale];
                sameweekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]];
            }
            chatCell.lastestMessageDate.text = [sameweekDateFormatter stringFromDate:lastestMessage.date];
        } else {
            //Earlier than one week
            static NSDateFormatter *earlierWeekDateFormatter = nil;
            if (earlierWeekDateFormatter == nil) {
                earlierWeekDateFormatter = [NSDateFormatter new];
                earlierWeekDateFormatter.locale = [NSLocale currentLocale];
                earlierWeekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Mdy" options:0 locale:[NSLocale currentLocale]];
            }
            chatCell.lastestMessageDate.text = [earlierWeekDateFormatter stringFromDate:lastestMessage.date];
        }
    }
    
    chatCell.lastestMessageBody.text = lastestMessage.body;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUser != YES"];
    RGSUser *participant = [[chat.participants filteredSetUsingPredicate:predicate] anyObject];
    
    chatCell.participantName.text = participant.login;
    [chatCell.participantName sizeToFit];
    chatCell.participantName.layer.borderColor = [[UIColor redColor] CGColor];
//    chatCell.participantName.layer.borderWidth = 2;
    
    chatCell.participantImage.image = [UIImage imageWithData:participant.imageData];
    chatCell.participantImage.layer.masksToBounds = YES;
    //prevent every frame from requiring a re-mask on all the pixels
    //http://stackoverflow.com/questions/4314640/setting-corner-radius-on-uiimageview-not-working#4314683
    chatCell.participantImage.layer.shouldRasterize = YES;
    [chatCell.participantImage.layer setCornerRadius:10];
    
    chatCell.alertBadge.layer.cornerRadius = chatCell.alertBadge.bounds.size.width/2;
//    chatCell.alertBadge = nil;
//    [chatCell.contentView bringSubviewToFront:chatCell.alertBadge];
    
    // Configure the cell...
//    cell.layer.borderWidth = 2;
    
//    [chatCell.participantName setFrameOriginY:10];
//    [chatCell.participantName setFrameOriginX:68];
//    [chatCell.lastestMessageBody setFrameOriginY:27];
//    [chatCell.lastestMessageBody setFrameOriginX:72];
    
    
    return chatCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RGSChatCell *cell = (RGSChatCell *)[tableView cellForRowAtIndexPath:indexPath];
//    UIView *backGround = [cell customSelectedBackgroundViewWithFrame:cell.frame];
//    [cell.contentView addSubview:backGround];
//    [cell.contentView sendSubviewToBack:backGround];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        contactListViewController.navigationItem.title = @"Select Contact";
        contactListViewController.showLeftBarButtonItem = YES;
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
            
            RGSMessageListViewController *messageListViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSMessageListViewController"];
            messageListViewController.chat = [result firstObject];
            messageListViewController.receiver = ((RGSContact *)[result firstObject]).friend;
            
        } else {
            //create Chat from Contact
            RGSChat *chat = [RGSChat MR_createEntity];
            [chat addParticipants:[NSSet setWithObjects:contact.friend, contact.source, nil]];
        
            RGSMessageListViewController *messageListViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RGSMessageListViewController"];
            messageListViewController.chat = chat;
            messageListViewController.receiver = contact.friend;
            
            [self.navigationController pushViewController:messageListViewController animated:YES];
            
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
-(void)dealloc{
    [self deregisterForNSManagedObjectNotifications];
}
- (void)deregisterForNSManagedObjectNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}

- (IBAction)unwindToChatList:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
