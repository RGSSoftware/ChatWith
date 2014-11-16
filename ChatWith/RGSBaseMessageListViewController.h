//
//  RGSBaseMessageListViewController.h
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseViewController.h"
@class RGSManagedUser;
@class RGSChat;
@class RGSMessageComposerView;

@interface RGSBaseMessageListViewController : RGSBaseViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)RGSManagedUser *receiver;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)RGSChat *chat;

@property (weak, nonatomic) IBOutlet RGSMessageComposerView *messageComposerView;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end
