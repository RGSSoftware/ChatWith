//
//  RGSNavigationController.m
//  ChatWith
//
//  Created by PC on 11/27/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSNavigationController.h"
#import "RGSPopSegue.h"

#import "RGSPushAnimationController.h"
#import "RGSPopAnimationController.h"

#import "RGSShowModallyAnimatonController.h"
#import "RGSDismissModallyAnimatonController.h"

#import "RGSShowOverviewAnimatonController.h"
#import "RGSDismissOverviewAnimatonController.h"

#import "RGShowSideMenuAnimationController.h"
#import "RGSCloseSideMenuAnimationController.h"

#import "RGSChatListViewController.h"
#import "RGSContactListViewController.h"
#import "RGSSideMenuViewController.h"


@interface RGSNavigationController ()
@property(nonatomic, strong)RGSPopSegue *popSegue;
@end

@implementation RGSNavigationController 

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.popSegue = [RGSPopSegue new];
    self.delegate = self;
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
    self.popSegue.toViewController = toViewController;
    self.popSegue.fromViewController = fromViewController;
    return self.popSegue;
}

-(id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(RGSBaseViewController *)fromVC toViewController:(UIViewController *)toVC{
    if([fromVC isKindOfClass:[RGSChatListViewController class]] && [toVC isKindOfClass:[RGSContactListViewController class]]){
        if(operation == UINavigationControllerOperationPush) return [RGSShowModallyAnimatonController new];
        
    } else if ([fromVC isKindOfClass:[RGSContactListViewController class]] && [toVC isKindOfClass:[RGSChatListViewController class]]){
        if(operation == UINavigationControllerOperationPop) return [RGSDismissModallyAnimatonController new];
    }
    if([toVC isKindOfClass:[RGSSideMenuViewController class]]){
        if(operation == UINavigationControllerOperationPush){
            return [RGShowSideMenuAnimationController new];
        }
    } else if ([fromVC isKindOfClass:[RGSSideMenuViewController class]]){
        if(operation == UINavigationControllerOperationPop) {
            return [RGSCloseSideMenuAnimationController new];
        }
        
    }
    if(operation == UINavigationControllerOperationPush) return [RGSPushAnimationController new];
    else return [RGSPopAnimationController new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [RGSShowOverviewAnimatonController new];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [RGSDismissOverviewAnimatonController new];
}
@end
