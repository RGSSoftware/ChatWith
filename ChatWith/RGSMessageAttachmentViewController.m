//
//  RGSMessageAttachmentViewController.m
//  ChatWith
//
//  Created by PC on 11/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageAttachmentViewController.h"
#import "RGSBaseMessageListViewController.h"
#import "RGSMessageComposerView.h"
#import "CSGrowingTextView.h"


@interface RGSMessageAttachmentViewController ()

@end

@implementation RGSMessageAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecongnizer:)];
    [self.view addGestureRecognizer:tapGestureRecongnizer];
}

-(void)tapRecongnizer:(UIGestureRecognizer *)sender{
    
    CGPoint userTouchCoordinate = [sender locationInView:nil];
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if(CGRectContainsPoint(self.cancelAttachmentButton.frame, userTouchCoordinate))return;
        if(!CGRectContainsPoint(self.choosePhotoButton.frame, userTouchCoordinate) ||
           !CGRectContainsPoint(self.takePhotoButton.frame, userTouchCoordinate)){
            
            
        }
    }
}


- (IBAction)choosePhoto:(id)sender {
    
    
}

- (IBAction)takePhoto:(id)sender {
}

- (IBAction)cancelAttachment:(id)sender {
    
//    RGSBaseMessageListViewController *pvc = (RGSBaseMessageListViewController *)self.presentingViewController;
//    
//    [pvc.messageComposerView.messageTextView becomeFirstResponder];
    [self dismissViewControllerAnimated:NO completion:^{
//        RGSBaseMessageListViewController *pvc = (RGSBaseMessageListViewController *)self.presentingViewController;
//        
//        [pvc.messageComposerView.messageTextView becomeFirstResponder];
    }];
}
@end
