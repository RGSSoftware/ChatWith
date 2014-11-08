//
//  RGSMessageListViewController.h
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSBaseViewController.h"

@class RGSManagedUser;

@interface RGSMessageListViewController : RGSBaseViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)RGSManagedUser *receiver;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@end
