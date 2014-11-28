//
//  UINavigationController+RGSBlock.m
//  ChatWith
//
//  Created by PC on 11/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "UINavigationController+RGSBlock.h"
#import <objc/runtime.h>

@implementation UINavigationController (RGSBlock)

-(UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)())popCompletion{
    self.popCompletion = popCompletion;
    return [self popViewControllerAnimated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.popCompletion != nil) self.popCompletion();
    self.popCompletion = nil;
    
}

- (void)setPopCompletion:(void (^)())popCompletion
{
    objc_setAssociatedObject(self, @selector(popCompletion), popCompletion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)())popCompletion
{
    return objc_getAssociatedObject(self, @selector(popCompletion));
}
@end
