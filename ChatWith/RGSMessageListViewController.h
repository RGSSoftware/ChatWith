//
//  RGSMessageListViewController.h
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RGSManagedUser;

@interface RGSMessageListViewController : UIViewController

@property (nonatomic, strong)RGSManagedUser *receiver;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

-(id)initWithFriend:(RGSManagedUser *)friendfgf;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
