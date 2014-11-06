//
//  RGSConverstationTableViewController.h
//  ChatWith
//
//  Created by PC on 10/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSBaseViewController.h"

@interface RGSChatListViewController : RGSBaseViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end
