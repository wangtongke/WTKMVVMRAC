//
//  UIViewController+WTKAnimationTransitioningSnapshot.m
//  WTKPushAndPopAnimation
//
//  Created by 王同科 on 16/9/22.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UIViewController+WTKAnimationTransitioningSnapshot.h"

#import <objc/runtime.h>
@implementation UIViewController (WTKAnimationTransitioningSnapshot)

- (UIView *)snapshot
{
    UIView *view = objc_getAssociatedObject(self, @"WTKAnimationTransitioningSnapshot");
    if (!view)
    {
        view = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
        [self setSnapshot:view];
    }
    return view;
}

- (void)setSnapshot:(UIView *)snapshot
{
    objc_setAssociatedObject(self, @"WTKAnimationTransitioningSnapshot", snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)topSnapshot
{
    UIView *view = objc_getAssociatedObject(self, @"WTKAnimationTransitioningTopSnapshot");
    if(!view)
    {
        view = [self.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
//        view = [self.navigationController.navigationBar snapshotViewAfterScreenUpdates:NO];
//        UIGraphicsBeginImageContext(CGSizeMake([[UIScreen mainScreen] bounds].size.width, 64));
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [self.navigationController.navigationBar.layer renderInContext:context];
//        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        UIImageView *imgView = [[UIImageView alloc]initWithImage:theImage];
        
        [self setTopSnapshot:view];
    }
    return view;
}
- (void)setTopSnapshot:(UIView *)topSnapshot
{
    objc_setAssociatedObject(self, @"WTKAnimationTransitioningTopSnapshot", topSnapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)viewSnapshot
{
    UIView *view = objc_getAssociatedObject(self, @"WTKAnimationTransitioningViewSnapshot");
    if (!view)
    {
        view = [self.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 64, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        [self setViewSnapshot:view];
    }
    return view;
}

- (void)setViewSnapshot:(UIView *)viewSnapshot
{
    objc_setAssociatedObject(self, @"WTKAnimationTransitioningViewSnapshot", viewSnapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
