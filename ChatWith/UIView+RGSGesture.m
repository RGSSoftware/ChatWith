//
//  UIView+RGSGesture.m
//  ChatWith
//
//  Created by PC on 1/9/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "UIView+RGSGesture.h"

@implementation UIView (RGSGesture)
-(void)removeAllGestureRecognizers{
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeGestureRecognizer:obj];
    }];
}

@end
