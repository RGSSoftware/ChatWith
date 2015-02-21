//
//  RGSChatCell.m
//  ChatWith
//
//  Created by PC on 11/7/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChatCell.h"

@implementation RGSChatCell

-(UIView *)customSelectedBackgroundViewWithFrame:(CGRect)frame{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.506 alpha:0.230];
    return selectedBackgroundView;
}
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
@end
