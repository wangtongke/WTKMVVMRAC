//
//  WTKBaseAnimation.m
//  WTKPushAndPopAnimation
//
//  Created by 王同科 on 16/9/22.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBaseAnimation.h"
#import "WTKAnimationDefault.h"
#import "WTKAnimationKuGou.h"
#import "WTKAnimationDiffNavi.h"
#import "WTKAnimationRound.h"
#import "WTKAnimationOval.h"

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width

const static NSTimeInterval DefauleAnimationDuration = 0.6;

@interface WTKBaseAnimation ()

@property(nonatomic,assign)NSTimeInterval duration;
@property(nonatomic,assign,readwrite)UINavigationControllerOperation transitionType;

@end


@implementation WTKBaseAnimation



//- (instancetype)init
//{
////  默认 push 动画时间0.6
//    if (self = [self initWithType:UINavigationControllerOperationPush Duration:DefauleAnimationDuration animateType:WTKAnimateTypeDefault])
//    {}
//    return self;
//}
///构造实例
- (instancetype)initWithType:(UINavigationControllerOperation)transitionType Duration:(NSTimeInterval)duration animateType:(WTKAnimateType)animaType
{
    switch (animaType)
    {
        case WTKAnimateTypeDefault:
        {
            self = [[WTKAnimationDefault alloc]init];
        }
            break;
        case WTKAnimateTypeDiffNavi:
        {
            self = [[WTKAnimationDiffNavi alloc]init];
        }
            break;
        case WTKAnimateTypeKuGou:
        {
            self = [[WTKAnimationKuGou alloc]init];
        }
            break;
        case WTKAnimateTypeRound:
        {
            self = [[WTKAnimationRound alloc]init];
        }
            break;
        case WTKAnimateTypeOval:
        {
            self = [[WTKAnimationOval alloc]init];
        }
            break;
            
        default:
            break;
    }
    
    if (self)
    {
        self.duration       = duration;
        self.transitionType = transitionType;
    }
    return self;
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType animateType:(WTKAnimateType)animaType
{
    return [self transitionWithType:transitionType duration:DefauleAnimationDuration animateType:animaType];
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration animateType:(WTKAnimateType)animaType
{
    return [self transitionWithType:transitionType duration:duration interactivePopTransition:nil animateType:animaType];
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration interactivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition animateType:(WTKAnimateType)animaType
{
    WTKBaseAnimation *animation = [[self alloc]initWithType:transitionType Duration:duration animateType:animaType];
    animation.interactivePopTransition = interactivePopTransition;
    return animation;
}

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext{}
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext{}
- (void)pushEnded{}
- (void)popEnded{}

#pragma mark - UIViewControllerAnimationTransition


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.transitionType == UINavigationControllerOperationPush)
    {
        [self push:transitionContext];
    }
    else if (self.transitionType == UINavigationControllerOperationPop)
    {
        [self pop:transitionContext];
    }
}
- (void)animationEnded:(BOOL)transitionCompleted
{
    if (!transitionCompleted)
    {
        return;
    }
    if (self.transitionType == UINavigationControllerOperationPush)
    {
        [self pushEnded];
    }
    else if (self.transitionType == UINavigationControllerOperationPop)
    {
        [self popEnded];
    }
}







@end
