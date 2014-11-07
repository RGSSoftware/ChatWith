//
//  RGSConverstationTableViewController.m
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatListViewController.h"
#import "RGSChat.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

@interface RGSChatListViewController ()

@end

@implementation RGSChatListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          for(NSManagedObject *object in [[note userInfo] objectForKey:NSUpdatedObjectsKey]){
                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSChat class])]){
                                                                  
                                                                  NSError *error;
                                                                  if (![[self fetchedResultsController] performFetch:&error]) {
                                                                      // Update to handle the error appropriately.
                                                                      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                                                                  } else {
                                                                      [self.tableView reloadData];
                                                                  }
                                                                  
                                                                  break;
                                                              }
                                                          }
                                                          
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
    return [sectionInfo numberOfObjects];
}

-(IBAction)enableEditingMode:(id)sender{
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"nil" cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

@end
