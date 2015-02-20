//
//  RGSChatCell.h
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lastestMessageBody;
@property (weak, nonatomic) IBOutlet UILabel *lastestMessageDate;

@property (weak, nonatomic) IBOutlet UIImageView *participantImage;
@property (weak, nonatomic) IBOutlet UILabel *participantName;

@property (weak, nonatomic) IBOutlet UIView *alertBadge;

-(UIView *)customSelectedBackgroundViewWithFrame:(CGRect)frame;
@end
