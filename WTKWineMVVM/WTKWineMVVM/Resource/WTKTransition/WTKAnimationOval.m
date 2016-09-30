//
//  WTKAnimationOval.m
//  WTKTransitionAnimation
//
//  Created by 王同科 on 16/9/28.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAnimationOval.h"
#import "WTKBasedViewController.h"
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface WTKAnimationOval ()

@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,weak)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation WTKAnimationOval

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    self.isPush                 = YES;
    self.transitionContext      = transitionContext;
    
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    
    CGRect bounds               = [[UIScreen mainScreen]bounds];
    
    UIView *containView         = [transitionContext containerView];
    
    fromVC.view.hidden          = YES;
    
    [containView addSubview:fromVC.snapshot];
    [containView addSubview:toVC.view];
    [[toVC.navigationController.view superview] insertSubview:fromVC.snapshot belowSubview:toVC.navigationController.view];
    
    CGRect frame                = CGRectMake(kWidth / 2.0 - 0.5, kHeight / 2.0 - 0.5, 1, 1);
    
    
    //    UIBezierPath *startPath     = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:0];
    //    内切圆
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:frame];
    float radius                = sqrtf(kHeight * kHeight / 4.0 + kWidth * kWidth / 4.0);
//    UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, -radius, -radius)];
        UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-kWidth / 4.0, -kHeight / 4.0, kWidth * 1.5, kHeight * 1.5)];
    
    CAShapeLayer *maskLayer     = [CAShapeLayer layer];
    maskLayer.path              = endPath.CGPath;
    toVC.navigationController.view.layer.mask        = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue         = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue           = (__bridge id _Nullable)(endPath.CGPath);
    animation.duration          = duration ;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.delegate          = self;
    
    [maskLayer addAnimation:animation forKey:@"start"];
    
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPush                 = NO;
    self.transitionContext      = transitionContext;
    
    WTKBasedViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    if(fromVC.interactivePopTransition)
    {
        duration = duration * 0.66;
    }
    UIView *containView         = [transitionContext containerView];
    
    fromVC.view.hidden          = YES;
    fromVC.navigationController.navigationBar.hidden = YES;
    [containView addSubview:toVC.view];
    [containView addSubview:toVC.snapshot];
    [containView sendSubviewToBack:toVC.snapshot];
    [containView addSubview:fromVC.snapshot];
    
    CGRect frame                = CGRectMake(kWidth / 2.0 - 0.5, kHeight / 2.0 - 0.5, 1, 1);
    float radiu                 = sqrtf(kHeight * kHeight / 4.0 + kWidth * kWidth / 4.0);
//    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, -radiu, -radiu)];
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-kWidth / 4.0, -kHeight / 4.0, kWidth * 1.5, kHeight * 1.5)];
    UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    CAShapeLayer *maskLayer     = [CAShapeLayer layer];
    maskLayer.path              = endPath.CGPath;
    fromVC.snapshot.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue         = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue           = (__bridge id _Nullable)(endPath.CGPath);
    animation.duration          = duration;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.delegate          = self;
    
    [maskLayer addAnimation:animation forKey:@"end"];
    
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if (self.isPush)
    {
        [self.transitionContext completeTransition:YES];
        UIViewController *fromVC    = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC.view.hidden = NO;
        [fromVC.snapshot removeFromSuperview];
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        
    }
    else
    {
        UIViewController *fromVC    = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC      = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.hidden            = NO;
        toVC.navigationController.navigationBar.hidden = NO;
        [fromVC.snapshot removeFromSuperview];
        [toVC.snapshot removeFromSuperview];
        fromVC.snapshot             = nil;
        //        updateInteractiveTransition
        
        if (![self.transitionContext transitionWasCancelled])
        {
            toVC.snapshot               = nil;
            [self.transitionContext completeTransition:YES];
        }
        else
        {
            [self.transitionContext completeTransition:NO];
        }
    }
}

@end
