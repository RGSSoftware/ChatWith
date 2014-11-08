//
//  RGSConverstationTableViewController.m
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatListViewController.h"
#import "RGSChat.h"
#import "RGSChatCell.h"
#import "RGSMessage.h"
#import "RGSManagedUser.h"
#import "NSDate+Utilities.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

@interface RGSChatListViewController ()

@end

@implementation RGSChatListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
//                                                          NSError *error;
//                                                          if (![[self fetchedResultsController] performFetch:&error]) {
//                                                              // Update to handle the error appropriately.
//                                                              NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                                                          } else {
//                                                              [self.tableView reloadData];
//                                                          }

//                                                          for(NSManagedObject *object in [[note userInfo] objectForKey:NSUpdatedObjectsKey]){
//                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSChat class])]){
//                                                                  
//                                                                  NSError *error;
//                                                                  if (![[self fetchedResultsController] performFetch:&error]) {
//                                                                      // Update to handle the error appropriately.
//                                                                      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                                                                  } else {
//                                                                      [self.tableView reloadData];
//                                                                  }
//                                                                  
//                                                                  break;
//                                                              }
//                                                          }
                                                          
                                                      }];
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add"] resizedImage:CGSizeMake(20, 20)]
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(toContacts:)];
    addBarButton.tintColor = [UIColor colorWithHexString:@"46ABCC"];
    self.navigationItem.leftBarButtonItem = addBarButton;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.backgroundView.hidden = YES;
    
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

-(IBAction)enableEditingMode:(id)sender{
    
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
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    }
    RGSChat *chat = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.lastestMessageDate.text = chat.lastMessageDate.description;
    
    if ([chat.lastMessageDate isEarlierThanDate:[NSDate date]]) {
        if ([chat.lastMessageDate isToday]) {
            static NSDateFormatter *todayDateFormatter = nil;
            if (todayDateFormatter == nil) {
                todayDateFormatter = [NSDateFormatter new];
                todayDateFormatter.dateFormat = @"hh:mm a";
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
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSFetchedResultsController *)fetchedResultsController{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[RGSChat MR_entityDescription]];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"lastMessageDate" ascending:NO]]];
    
    
    [fetchRequest setFetchBatchSize:20];
    
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"sender.currentUser", [NSNumber numberWithBool:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

@end
