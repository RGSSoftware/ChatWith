//
//  RGSBaseAnimatonController.m
//  ChatWith
//
//  Created by PC on 12/9/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseAnimationController.h"


@interface RGSBaseAnimationController ()
@property(nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;


@end

@implementation RGSBaseAnimationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionDuration = .21;
        
        self.centerScreenRect = CGRectZero;
        
        CGRect leftOffScreenRect = CGRectZero;
        leftOffScreenRect.origin = CGPointMake(-1 * [UIScreen mainScreen].bounds.size.width, 0);
        self.leftOffScreenRect = leftOffScreenRect;
        
        CGRect rightOffScreenRect = CGRectZero;
        rightOffScreenRect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
        self.rightOffScreenRect = rightOffScreenRect;
        
        CGRect bottomOffScreenRect = CGRectZero;
        bottomOffScreenRect.origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height);
        self.bottomOffScreenRect = bottomOffScreenRect;
        
        CGRect topOffScreenRect = CGRectZero;
        topOffScreenRect.origin = CGPointMake(0, -1 * [UIScreen mainScreen].bounds.size.height);
        self.topOffScreenRect = topOffScreenRect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    return self.transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(UIViewController *)fromViewController{
    if(self.transitionContext){
        return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    return nil;
}

-(UIViewController *)toViewController{
    if(self.transitionContext){
        return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    return nil;
}

-(void)setCenterScreenRectSize:(CGSize)size{
    CGRect rect = self.centerScreenRect;
    rect.size = size;
    self.centerScreenRect = rect;
}

-(void)setLeftOffScreenRectSize:(CGSize)size{
    CGRect rect = self.leftOffScreenRect;
    rect.size = size;
    self.leftOffScreenRect = rect;
}

-(void)setRightOffScreenRectSize:(CGSize)size{
    CGRect rect = self.rightOffScreenRect;
    rect.size = size;
    self.rightOffScreenRect = rect;
}

-(void)setBottomOffScreenRectSize:(CGSize)size{
    CGRect rect = self.bottomOffScreenRect;
    rect.size = size;
    self.bottomOffScreenRect = rect;
}

-(void)setTopOffScreenRectSize:(CGSize)size{
    CGRect rect = self.topOffScreenRect;
    rect.size = size;
    self.topOffScreenRect = rect;
}
@end
