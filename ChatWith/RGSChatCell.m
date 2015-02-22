//
//  RGSChatCell.m
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatCell.h"

@interface RGSChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *lastestMessageBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastestMessageDate;

@property (strong,nonatomic) UIView *redAlertBadge;
@property (strong,nonatomic) UIView *whiteAlertBadge;
@end

@implementation RGSChatCell

//pervert UIView backgroundColor from disappearing when UITableViewCell is selected
//http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected#21661997
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.alertBadge.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.alertBadge.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.alertBadge.backgroundColor;
    [super setSelected:selected animated:animated];
    self.alertBadge.backgroundColor = backgroundColor;
}

-(void)awakeFromNib{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.506 alpha:0.230];
    self.selectedBackgroundView = selectedBackgroundView;
    
    self.participantImage.layer.masksToBounds = YES;
    //prevent every frame from requiring a re-mask on all the pixels
    //http://stackoverflow.com/questions/4314640/setting-corner-radius-on-uiimageview-not-working#4314683
    self.participantImage.layer.shouldRasterize = YES;
    [self.participantImage.layer setCornerRadius:10];
    
     self.alertBadge.layer.cornerRadius = self.alertBadge.bounds.size.width/2;
    self.alertBadge.hidden = YES;
    self.alertBadge.alpha = 0;

}

-(void)setLastestMessageDateWithFormat:(NSDate *)date{
    if ([date isEarlierThanDate:[NSDate date]]) {
        if ([date isToday]) {
            static NSDateFormatter *todayDateFormatter = nil;
            if (todayDateFormatter == nil) {
                todayDateFormatter = [NSDateFormatter new];
                todayDateFormatter.dateFormat = @"h:mm a";
            }
            self.lastestMessageDate.text = [todayDateFormatter stringFromDate:date];
        } else if ([date isYesterday]){
            self.lastestMessageDate.text = @"Yesterday";
            
        } else if ([date isSameWeekAsDate:[NSDate date]]){
            static NSDateFormatter *sameweekDateFormatter = nil;
            if (sameweekDateFormatter == nil) {
                sameweekDateFormatter = [NSDateFormatter new];
                sameweekDateFormatter.locale = [NSLocale currentLocale];
                sameweekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]];
            }
            self.lastestMessageDate.text = [sameweekDateFormatter stringFromDate:date];
        } else {
            //Earlier than one week
            static NSDateFormatter *earlierWeekDateFormatter = nil;
            if (earlierWeekDateFormatter == nil) {
                earlierWeekDateFormatter = [NSDateFormatter new];
                earlierWeekDateFormatter.locale = [NSLocale currentLocale];
                earlierWeekDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"Mdy" options:0 locale:[NSLocale currentLocale]];
            }
            self.lastestMessageDate.text = [earlierWeekDateFormatter stringFromDate:date];
        }
    }
}

-(void)setLastestMessageBody:(NSString *)lastestMessageBody{
    _lastestMessageBody = lastestMessageBody;
    
    self.lastestMessageBodyLabel.text = lastestMessageBody;
    CGSize expectedSize = [self.lastestMessageBodyLabel.text boundingRectWithSize:CGSizeMake(231, 43) font:self.lastestMessageBodyLabel.font].size;
    [self.lastestMessageBodyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(expectedSize.height));
    }];
}

-(void)showAlertBadgeWithAnimation{
    [self hideAlertBadge];
    [UIView animateWithDuration:.6 delay:0 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.alertBadge.hidden = NO;
        self.alertBadge.alpha = 1;
        
    } completion:nil];
}
-(void)hideAlertBadge{
    [self.layer removeAllAnimations];
    self.alertBadge.hidden = YES;
    self.alertBadge.alpha = 0;
}
@end
