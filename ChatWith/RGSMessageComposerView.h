//
//  RGSMessageComposerView.h
//  ChatWith
//
//  Created by PC on 11/16/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSGrowingTextView.h"

@interface RGSMessageComposerView : UIView <CSGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *addImageButton;
@property (nonatomic, weak)IBOutlet UIButton *sendMessagebButton;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;

@property(nonatomic)CGRect hitRect;

@end
