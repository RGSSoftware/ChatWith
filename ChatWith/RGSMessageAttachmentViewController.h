//
//  RGSMessageAttachmentViewController.h
//  ChatWith
//
//  Created by PC on 11/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSMessageAttachmentViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAttachmentButton;

@property (nonatomic, weak) id delegate;

- (IBAction)choosePhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cancelAttachment:(id)sender;
@end

@protocol RGSMessageAttachmentViewControllerDelegate <NSObject>

-(void)RGSMessageAttachmentViewController:(RGSMessageAttachmentViewController *)messageAttachmentViewController imageAttachment:(UIImage *)imageAttachment;
@end