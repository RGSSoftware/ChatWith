//
//  RGSRegistrationViewController.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSRegistrationViewController.h"

#import "UIColor+RGSColorWithHexString.h"

#import "NSAttributedString+RGSExtras.h"
#import "NSMutableAttributedString+RGSExtras.h"
#import "NSString+RGSAttributedString.h"

@interface RGSRegistrationViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;
@property (nonatomic, strong)NSMutableArray *buttons;
@end

@implementation RGSRegistrationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self baseInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit{
    
    _textFields = [NSMutableArray array];
    _buttons = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.textFields addObjectsFromArray:@[self.usernameTextField,
                                           self.passwordTextField,
                                           self.emailTextField,
                                           self.firstnameTextField,
                                           self.lastnameTextField,
                                           self.phonenumberTextField]];
    
    for (UITextField *textField in self.textFields) {
        textField.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
        textField.layer.borderColor = [[UIColor clearColor] CGColor];
        textField.textColor = [UIColor whiteColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 10;
        
        NSMutableAttributedString *attributedString = [[textField.placeholder attributedString] mutableCopy];
        [attributedString setColor:[UIColor colorWithWhite:0.830 alpha:1.000]];
        textField.attributedPlaceholder = attributedString;
    }
    
    [self.buttons addObjectsFromArray:@[self.addUserImageButtom, self.submitButton]];
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
        [button.layer setCornerRadius:10];
        [button setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) + 150);
}


- (IBAction)addUserImage:(id)sender {
}

- (IBAction)submit:(id)sender {
}
@end
