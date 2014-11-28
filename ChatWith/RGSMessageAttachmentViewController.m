//
//  RGSMessageAttachmentViewController.m
//  ChatWith
//
//  Created by PC on 11/23/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageAttachmentViewController.h"
#import "RGSMessageListViewController.h"
#import "RGSMessageComposerView.h"
#import "CSGrowingTextView.h"


@interface RGSMessageAttachmentViewController () 

@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong)UIImage *imagePicked;
@end

@implementation RGSMessageAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.imagePickerController.delegate = self;
    
    
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
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}


- (IBAction)choosePhoto:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

- (IBAction)takePhoto:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
     [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)cancelAttachment:(id)sender {[self dismissViewControllerAnimated:NO completion:nil];}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(RGSMessageAttachmentViewController:imageAttachment:)]) {
            [self.delegate RGSMessageAttachmentViewController:self imageAttachment:image];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)cancelPicker:(id)sender{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationItem *ipcNavBarTopItem;
    
    // add done button to right side of nav bar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Photos"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelPicker:)];
    
    UINavigationBar *bar = navigationController.navigationBar;
    [bar setHidden:NO];
    ipcNavBarTopItem = bar.topItem;
    ipcNavBarTopItem.title = @"Photos";
    ipcNavBarTopItem.leftBarButtonItem = doneButton;
}
@end
