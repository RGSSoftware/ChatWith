//
//  RGSPlaygroundViewController.m
//  ChatWith
//
//  Created by PC on 12/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPlaygroundViewController.h"

@interface RGSPlaygroundViewController ()

@end

@implementation RGSPlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
@end
