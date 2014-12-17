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
    
    if(self.newStack != nil){
        [NSTimer bk_scheduledTimerWithTimeInterval:.4
                                             block:^(NSTimer *timer) {
                                                [self setViewControllers:self.newStack animated:NO];
                                                self.newStack = nil;
            } repeats:NO];
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated withReplaceStack:(NSArray *)newStack{
    self.newStack = newStack;
    return [self popViewControllerAnimated:animated];
}

- (void)setPopCompletion:(void (^)())popCompletion
{
    objc_setAssociatedObject(self, @selector(popCompletion), popCompletion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)())popCompletion
{
    return objc_getAssociatedObject(self, @selector(popCompletion));
}

- (void)setNewStack:(NSArray *)newStack
{
    objc_setAssociatedObject(self, @selector(newStack), newStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)newStack
{
    return objc_getAssociatedObject(self, @selector(newStack));
}
@end
