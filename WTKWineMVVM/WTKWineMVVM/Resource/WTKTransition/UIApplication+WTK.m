//
//  UIApplication+WTK.m
//  WTKTransitionAnimation
//
//  Created by 王同科 on 16/9/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UIApplication+WTK.h"
#import <objc/runtime.h>
#import "WTKTouchManager.h"

@implementation UIApplication (WTK)

+ (void)load
{
    Method originMethod     = class_getInstanceMethod(NSClassFromString(@"UIApplication"), @selector(sendEvent:));
    Method newMethod        = class_getInstanceMethod(NSClassFromString(@"UIApplication"), @selector(wtk_sendEvent:));
    method_exchangeImplementations(originMethod, newMethod);
}

- (void)wtk_sendEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event touchesForWindow:[[UIApplication sharedApplication].delegate window]] anyObject];

    CGPoint touchPoint      = [touch locationInView:[[UIApplication sharedApplication].delegate window]];
    
    [WTKTouchManager shareManager].touchPoint = touchPoint;
    
    
    [self wtk_sendEvent:event];
}

@end
