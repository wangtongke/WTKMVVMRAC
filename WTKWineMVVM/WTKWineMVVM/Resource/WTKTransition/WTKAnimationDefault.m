//
//  WTKAnimationDefault.m
//  WTKPushAndPopAnimation
//
//  Created by 王同科 on 16/9/23.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAnimationDefault.h"
#import "WTKBasedViewController.h"
#import "UIViewController+WTKAnimationTransitioningSnapshot.h"

@implementation WTKAnimationDefault

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    
    CGRect bounds               = [[UIScreen mainScreen] bounds];
    
    fromVC.view.hidden         = YES;

    [[transitionContext containerView] addSubview:fromVC.snapshot];
    //    此处调用viewSnapshot，push之前获取topSnapshot,viewSnapshot
    [[transitionContext containerView] addSubview:fromVC.topSnapshot];
    [fromVC.viewSnapshot removeFromSuperview];
    
    
    [[transitionContext containerView] addSubview:toVC.view];
    [[toVC.navigationController.view superview] insertSubview:fromVC.snapshot belowSubview:toVC.navigationController.view];
    
    toVC.navigationController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVC.snapshot.alpha = 0.5;
                         fromVC.snapshot.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(bounds) * 0.3, 0);
//                         fromVC.topSnapshot.alpha = 0.5;
                         toVC.navigationController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         fromVC.view.hidden = NO;
                         fromVC.snapshot.alpha = 1;
                         [fromVC.snapshot removeFromSuperview];
//                         [fromVC.topSnapshot removeFromSuperview];
                         [toVC.snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
    }];
    
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    WTKBasedViewController *fromVC   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC          = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration         = [self transitionDuration:transitionContext];
    CGRect bound                    = [[UIScreen mainScreen] bounds];
    
    [fromVC.view addSubview:fromVC.snapshot];
    fromVC.navigationController.navigationBar.hidden = YES;
    fromVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
    

    
    fromVC.snapshot.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor;
    fromVC.snapshot.layer.shadowOffset = CGSizeMake(-3, 0);
    fromVC.snapshot.layer.shadowOpacity = 0.5;
//    fromVC.snapshot.layer.shadowRadius = 1;
   
    

    toVC.view.hidden = YES;
    toVC.viewSnapshot.alpha = 0.8;
    toVC.viewSnapshot.transform = CGAffineTransformMakeTranslation(-bound.size.width / 2.0, 64);
    toVC.topSnapshot.alpha = 0.5;
    
    [[transitionContext containerView] addSubview:toVC.view];
    [[transitionContext containerView] addSubview:toVC.viewSnapshot];
    [[transitionContext containerView] sendSubviewToBack:toVC.viewSnapshot];
    [[transitionContext containerView] addSubview:toVC.topSnapshot];

    
    if (fromVC.interactivePopTransition)
    {
//        右滑返回

        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toVC.topSnapshot.alpha = 1;
                             fromVC.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bound) + 3, 0);
                             toVC.viewSnapshot.alpha = 1.0;
                             toVC.viewSnapshot.transform = CGAffineTransformMakeTranslation(0, 64);
                         }
                         completion:^(BOOL finished) {

                             toVC.navigationController.navigationBar.hidden = NO;
                             toVC.view.hidden = NO;
                             
                             [fromVC.snapshot removeFromSuperview];
                             [toVC.viewSnapshot removeFromSuperview];
                             [toVC.snapshot removeFromSuperview];
                             [fromVC.topSnapshot removeFromSuperview];
                             [toVC.topSnapshot removeFromSuperview];
                             
                             fromVC.snapshot = nil;
                             fromVC.topSnapshot = nil;
                             
                             if (![transitionContext transitionWasCancelled])
                             {
                                 toVC.viewSnapshot = nil;
                                 toVC.topSnapshot = nil;
                                 toVC.snapshot = nil;
                             }
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
        }];
    }
    else
    {
//        点击返回按钮

        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toVC.topSnapshot.alpha = 1;
                             fromVC.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bound) + 3, 0);
                             toVC.viewSnapshot.alpha = 1.0;
                             toVC.viewSnapshot.transform = CGAffineTransformMakeTranslation(0, 64);
                         }
                         completion:^(BOOL finished) {
                             toVC.navigationController.navigationBar.hidden = NO;
                             toVC.view.hidden = NO;
                             
                             [fromVC.snapshot removeFromSuperview];
                             [toVC.viewSnapshot removeFromSuperview];
                             [toVC.snapshot removeFromSuperview];
                             [fromVC.topSnapshot removeFromSuperview];
                             [toVC.topSnapshot removeFromSuperview];
                             
                             fromVC.snapshot = nil;
                             fromVC.topSnapshot = nil;
                             
                             if (![transitionContext transitionWasCancelled])
                             {
                                 toVC.viewSnapshot = nil;
                                 toVC.topSnapshot = nil;
                                 toVC.snapshot = nil;
                             }
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
        }];
    }
    
    
}

@end
