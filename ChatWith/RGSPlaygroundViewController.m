//
//  RGSPlaygroundViewController.m
//  ChatWith
//
//  Created by PC on 12/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPlaygroundViewController.h"

#import "RGSMessage.h"

#import "RGSChatService.h"

#import "RGSBackBarButtonItem.h"

@interface RGSPlaygroundViewController ()

@end

@implementation RGSPlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 220, 40)];
    
    [backButton setTitleColor:[UIColor colorWithHexString:@"57d6ff"]
                     forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor]
                     forState:UIControlStateHighlighted];
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    
    
    [backButton setImage:[UIImage imageNamed:@"backArrowlarge"]
                forState:UIControlStateNormal];
//    backButton.imageView.layer.cornerRadius = 10;
    
//    [backButton setImage:[[UIImage imageNamed:@"backArrow_larger"] resizedImage:CGSizeMake(10, 25)]
//                forState:UIControlStateNormal];
    
    [backButton addTarget:nil action:nil
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Terminator" forState:UIControlStateNormal];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 0);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    
//    backButton.layer.borderWidth = 2;
    
    UIImageView *doneCheckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrowlarger2"]];
    doneCheckView.frame = CGRectMake(0, 20, CGRectGetWidth(doneCheckView.frame)/3, CGRectGetHeight(doneCheckView.frame)/3);
//    doneCheckView.layer.borderWidth = 1;
    doneCheckView.layer.borderColor = [[UIColor whiteColor] CGColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    [backView addSubview:doneCheckView];
//    backView.layer.borderWidth = 1;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = [[RGSBackBarButtonItem alloc] initWithTitle:@"Chat" handler:^(id sender) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 320, 100, 100)];
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
  }

-(void)handleTimer:(id)sender{
    RGSBackBarButtonItem *backButton = (RGSBackBarButtonItem *)self.navigationItem.leftBarButtonItem;
//
//    backButton.label.textColor = [UIColor whiteColor];
//    
//    [backButton.arrow setFrameOriginX:-5];
//    [backButton.arrow setFrameOriginY:15];
//    
    UILabel *label = backButton.label;
//
//    label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16];
//    
//    [label setFrameSizeWidth:50];
    [label setFrameOriginX:8];
//    [label setFrameOriginY:18];
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}

- (IBAction)search:(id)sender {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    filters[@"filter"] = @[[NSString stringWithFormat:@"string login le %@", self.textField.text]];
    
    [QBRequest usersWithExtendedRequest:filters page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
        NSLog(@"all good");
        self.resultLabel.text = @"";
        [users enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop)
        {
            if (idx == 0) {
                 self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", ((QBUUser *)item).login]];
            } else {
                self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@", %@", ((QBUUser *)item).login]];
            }
         }];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"ERORR");
    }];
    
//    [QBRequest userWithLogin:self.textField.text successBlock:^(QBResponse *response, QBUUser *user) {
//        NSLog(@"all good");
//    } errorBlock:^(QBResponse *response) {
//        NSLog(@"ERORR");
//    }];
    
}
- (IBAction)convert:(id)sender {
    self.resultLabel.text = NSStringFromCGRect([self.redView convertRect:self.greenView.frame toView:self.view]);
    
}
@end
