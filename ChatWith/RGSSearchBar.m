//
//  RGSSearchBar.m
//  ChatWith
//
//  Created by PC on 12/25/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSearchBar.h"
#import "NSAttributedString+RGSExtras.h"

@implementation RGSSearchBar
-(void)deSelect{
    UITextField *searchField = [self textField];
    if(searchField){
        searchField.attributedPlaceholder = [NSAttributedString attributedStringWithString:self.placeholder
                                                                                     Color:[UIColor whiteColor]];
        searchField.layer.borderWidth = 0;
        searchField.layer.cornerRadius = 8;
        searchField.textColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:.5 animations:^{self.backgroundColor = [UIColor clearColor];}];
        
    }
}
-(void)selectState{
    UITextField *searchField = [self textField];
    if(searchField){
        searchField.attributedPlaceholder = [NSAttributedString attributedStringWithString:self.placeholder
                                                                                     Color:[UIColor blackColor]];
        searchField.layer.borderWidth = 1;
        searchField.layer.cornerRadius = 8;
        searchField.textColor = [UIColor blackColor];
        
        [UIView animateWithDuration:.7 animations:^{self.backgroundColor = [UIColor whiteColor];}];
        
    }

}
-(UITextField *)textField{
    UITextField *searchField;
    for (UIView *subview in self.subviews) {
        for (UIView *subSubview in subview.subviews) {
            if ([subSubview isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)subSubview;
                break;
            }
        }
    }
    return searchField;
}

@end
