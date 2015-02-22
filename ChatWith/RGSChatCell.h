//
//  RGSChatCell.h
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSChatCell : UITableViewCell
@property (strong, nonatomic)NSString *lastestMessageBody;
@property (weak, nonatomic) IBOutlet UIImageView *participantImage;
@property (weak, nonatomic) IBOutlet UIView *participantPlaceholderImageView;
@property (weak, nonatomic) IBOutlet UILabel *participantName;

@property (weak, nonatomic) IBOutlet UIView *alertBadge;

-(void)setLastestMessageDateWithFormat:(NSDate *)date;

-(void)showAlertBadgeWithAnimation;
-(void)hideAlertBadge;

-(void)setParticipantImageData:(NSData *)imageData;

@end
