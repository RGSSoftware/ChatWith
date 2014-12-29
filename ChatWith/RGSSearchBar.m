//
//  RGSSearchBar.m
//  ChatWith
//
//  Created by PC on 12/25/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSSearchBar.h"
#import "NSAttributedString+RGSExtras.h"
#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.m"
#import "UIImage+Resize.h"

@implementation RGSSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            if (obj == nil) {
                
            }
            
            
        }];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImage = [UIImage imageWithColor:
                            [UIColor colorWithHexString:@"414141" alpha:.16]];
    
    [self setImage:[UIImage imageNamed:@"searchMagnifyingGlass_W"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self setImage:[[UIImage imageNamed:@"searchClear"] resizedImage:CGSizeMake(10, 10)] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self setImage:[[UIImage imageNamed:@"searchClear_Selected"] resizedImage:CGSizeMake(10, 10)] forSearchBarIcon:UISearchBarIconClear state:UIControlStateSelected];
    [self setPlaceholder:@"Search"];
    
    UITextField *searchField = [self textField];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.textColor = [UIColor blackColor];
    
    searchField.attributedPlaceholder = [NSAttributedString attributedStringWithString:searchField.placeholder
                                                                                 Color:[UIColor whiteColor]];
    
    searchField.layer.borderWidth = 1;
    searchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    searchField.layer.cornerRadius = 8;
    
    CGRect magnifingGlassRect = searchField.leftView.frame;
    magnifingGlassRect.size = CGSizeMake(18, 18);
    searchField.leftView.frame = magnifingGlassRect;
    
}

-(void)deSelect{
    [self setImage:[UIImage imageNamed:@"searchMagnifyingGlass_W"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField *searchField = [self textField];
    searchField.textColor = [UIColor whiteColor];
    if(searchField){
        searchField.attributedPlaceholder = [NSAttributedString attributedStringWithString:self.placeholder
                                                                                     Color:[UIColor whiteColor]];
        searchField.layer.borderColor = [[UIColor whiteColor] CGColor];
        NSLog(@"-----------------%@",self.text);
        
        if([self.text isEqualToString:@""]){
            searchField.textColor = [UIColor blackColor];

        } else {
            searchField.textColor = [UIColor whiteColor];
        }
        
        [UIView animateWithDuration:.5 animations:^{self.backgroundColor = [UIColor clearColor];}];
        
    }
}
-(void)selectState{
    [self setImage:[UIImage imageNamed:@"searchMagnifyingGlass_B"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    
    
    UITextField *searchField = [self textField];
    if(searchField){
        searchField.attributedPlaceholder = [NSAttributedString attributedStringWithString:self.placeholder
                                                                                     Color:[UIColor blackColor]];
        searchField.layer.borderColor = [[UIColor blackColor] CGColor];
        searchField.textColor = [UIColor blackColor];
        
        [UIView animateWithDuration:.6 animations:^{self.backgroundColor = [UIColor whiteColor];}];
        
    }
    searchField.textColor = [UIColor blackColor];

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
