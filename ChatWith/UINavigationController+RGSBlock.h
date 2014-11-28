//
//  UINavigationController+RGSBlock.h
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RGSBlock)

@property (nonatomic, strong)void(^popCompletion)();

-(UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)())popCompletion;

@end
