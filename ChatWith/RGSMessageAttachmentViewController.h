//
//  RGSMessageAttachmentViewController.h
//  ChatWith
//
//  Created by PC on 11/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSMessageAttachmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAttachmentButton;

- (IBAction)choosePhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cancelAttachment:(id)sender;
@end
