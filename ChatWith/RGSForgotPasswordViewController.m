//
//  RGSForgotPasswordViewController.m
//  ChatWith
//
//  Created by PC on 12/13/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSForgotPasswordViewController.h"

@interface RGSForgotPasswordViewController ()

@end

@implementation RGSForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reset:(id)sender {
    
    
    [QBRequest resetUserPasswordWithEmail:self.emailTextField.text successBlock:^(QBResponse *response) {
        // Reset was successful
        
        
    } errorBlock:^(QBResponse *response) {
        // Error
        
        
    }];
        
    

}
@end
