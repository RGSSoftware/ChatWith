//
//  RGSInviteViewController.m
//  ChatWith
//
//  Created by PC on 12/3/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSInviteViewController.h"
#import "IBActionSheet.h"

@interface RGSInviteViewController () <UIActionSheetDelegate, IBActionSheetDelegate>


@property IBActionSheet *standardIBAS;
@end

@implementation RGSInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"FaceBook", @"Text"]];
    
    [self.standardIBAS setButtonBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.75]];
    [self.standardIBAS setButtonTextColor:[UIColor whiteColor]];
    [self.standardIBAS setButtonTextColor:[UIColor blueColor] forButtonAtIndex:2];
    
    
    [self.standardIBAS showInView:self.view];
}

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    NSLog(@"Button at index: %ld clicked\nIt's title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}


-(void)actionSheetDidDismiss:(IBActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:NO completion:nil];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
