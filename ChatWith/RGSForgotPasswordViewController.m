//
//  RGSForgotPasswordViewController.m
//  ChatWith
//
//  Created by PC on 12/13/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSForgotPasswordViewController.h"

#import "UIColor+RGSColorWithHexString.h"
#import "NSAttributedString+RGSExtras.h"
#import "NSMutableAttributedString+RGSExtras.h"
#import "NSString+RGSAttributedString.h"

@interface RGSForgotPasswordViewController ()

@end

@implementation RGSForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    
    self.emailTextField.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    self.emailTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    self.emailTextField.textColor = [UIColor whiteColor];
    self.emailTextField.layer.borderWidth = 1;
    self.emailTextField.layer.cornerRadius = 10;
    
    NSMutableAttributedString *attributedString = [[self.emailTextField.placeholder attributedString] mutableCopy];
    [attributedString setColor:[UIColor colorWithWhite:0.830 alpha:1.000]];
    self.emailTextField.attributedPlaceholder = attributedString;
    
    self.resetButton.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
    [self.resetButton.layer setCornerRadius:10];
    [self.resetButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.resetButton.titleLabel.font = [UIFont systemFontOfSize:20];

    self.resetSuccessMessage.layer.cornerRadius = 10;
    self.resetSuccessMessage.alpha = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.emailTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailTextField setLeftView:spacerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)reset:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
        self.resetSuccessMessage.alpha = 1;
    } completion:^(BOOL finished) {
        [NSTimer bk_scheduledTimerWithTimeInterval:4 block:^(NSTimer *timer) {
            [UIView animateWithDuration:.3 animations:^{
                self.resetSuccessMessage.alpha = 0;
            }];
        } repeats:NO];
    }];
    
//    [QBRequest resetUserPasswordWithEmail:self.emailTextField.text successBlock:^(QBResponse *response) {
//        // Reset was successful
//        
//        
//    } errorBlock:^(QBResponse *response) {
//        // Error
//        
//        
//    }];
    
    

}
@end
