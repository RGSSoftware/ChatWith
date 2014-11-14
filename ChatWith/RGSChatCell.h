//
//  RGSChatCell.h
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *receiverImage;
@property (weak, nonatomic) IBOutlet UILabel *receiverName;
@property (weak, nonatomic) IBOutlet UILabel *lastestMessageBody;
@property (weak, nonatomic) IBOutlet UILabel *lastestMessageDate;

-(UIView *)customSelectedBackgroundViewWithFrame:(CGRect)frame;
@end
