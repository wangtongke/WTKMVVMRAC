//
//  UIViewController+WTKAnimationTransitioningSnapshot.h
//  WTKPushAndPopAnimation
//
//  Created by 王同科 on 16/9/22.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WTKAnimationTransitioningSnapshot)

/**
 *屏幕快照
 */
@property (nonatomic, strong) UIView *snapshot;

@property(nonatomic,strong)UIView *topSnapshot;

@property(nonatomic,strong)UIView *viewSnapshot;
@end
