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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"error running fetch on fetchedResultsController" forKey:NSLocalizedFailureReasonErrorKey];
        [errorDetail setValue:@"Couldn't show Chats because there's an error running a fetch on fetchedResultsController." forKey:NSLocalizedDescriptionKey];
        
        RGSLogReport *logReport = [RGSLogReport logReportFromErrorDic:@{LogReportLevelMain : [NSError errorWithDomain:RGSChatListErrorDomain code:EVCL userInfo:errorDetail], LogReportLevelSub : error}];
        if(logReport){
            [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                if(success)[RGSLogService sendLog:logReport successBlock:nil];
            }];
        }

    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
//    [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
//        [self.tableView reloadData];
//    } repeats:YES];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.showChat = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    int rowCount = (int)[sectionInfo numberOfObjects];
    return rowCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGSChatCell *chatCell;
    
    chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    
    RGSChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
   
    [chatCell setLastestMessageDateWithFormat:((RGSMessage *)chat.lastestMessage).date];
   
    chatCell.lastestMessageBody = ((RGSMessage *)chat.lastestMessage).body;
    
    RGSUser *participant = [[chat.participants filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"currentUser != YES"]] anyObject];
    
    chatCell.participantName.text = participant.login;
    
    if(participant.imageData) [chatCell setParticipantImageData:participant.imageData];
    
    
    if([chat.unreadMessagesCount integerValue] > 0){
        [chatCell showAlertBadgeWithAnimation];
    } else [chatCell hideAlertBadge];
    
    return chatCell;
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
        NSArray *result = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:fetchRequest error:&error];
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
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"lastestMessageDate" ascending:NO]]];
    [fetchRequest setFetchBatchSize:20];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%@ IN %K", [RGSUser findCurrentUser], @"participants"]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}

- (IBAction)unwindToChatList:(UIStoryboardSegue *)unwindSegue
{
    
}

-(void)toContacts:(id)sender{
    [self performSegueWithIdentifier:@"toContacts" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
