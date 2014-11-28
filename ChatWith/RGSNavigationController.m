//
//  RGSNavigationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSNavigationController.h"
#import "RGSPpopSegue.h"

#import "RGSPushAnimationController.h"
#import "RGSPopAnimationController.h"

@interface RGSNavigationController ()
@property(nonatomic, strong)RGSPpopSegue *popSegue;
@end

@implementation RGSNavigationController



-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.popSegue = [RGSPpopSegue new];
    self.delegate = self;
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
    self.popSegue.toViewController = toViewController;
    self.popSegue.fromViewController = fromViewController;
    return self.popSegue;
}

-(id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if(operation == UINavigationControllerOperationPush) return [RGSPushAnimationController new];
    else return [RGSPopAnimationController new];
}
@end
