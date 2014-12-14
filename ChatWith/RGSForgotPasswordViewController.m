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
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    self.emailTextField.bk_shouldReturnBlock = ^BOOL(UITextField *textField){
        [textField resignFirstResponder];
        return YES;
    };
    
    
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
    if([self validateEmail:self.emailTextField.text]){

        [QBRequest resetUserPasswordWithEmail:self.emailTextField.text successBlock:^(QBResponse *response) {
        [UIView animateWithDuration:.3 animations:^{
            self.resetSuccessMessage.alpha = 1;
        } completion:^(BOOL finished) {
            [NSTimer bk_scheduledTimerWithTimeInterval:4 block:^(NSTimer *timer) {
                [UIView animateWithDuration:.3 animations:^{
                    self.resetSuccessMessage.alpha = 0;
                }];
            } repeats:NO];
        }];
        } errorBlock:^(QBResponse *response) {
            // Error
            
            
        }];
    } else {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Oops! That's not a valid email. Give it another shot"];
        [alertView bk_setCancelButtonWithTitle:@"OKAY" handler:^{
            [self.emailTextField becomeFirstResponder];
        }];
        [alertView show];
        }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
@end
