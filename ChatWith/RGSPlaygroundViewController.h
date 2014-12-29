//
//  RGSPlaygroundViewController.h
//  ChatWith
//
//  Created by PC on 12/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSPlaygroundViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)search:(id)sender;

@end
