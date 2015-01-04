//
//  RGSContactDetailHandler.h
//  ChatWith
//
//  Created by PC on 12/30/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RGSContactListViewController.h"

@interface RGSContactDetailHandler : NSObject <RGSContactListViewControllerDelegate>

-(void)contactListViewController:(RGSContactListViewController *)contactListViewController didSelectContactAtIndex:(NSIndexPath *)contactIndex;
@end
