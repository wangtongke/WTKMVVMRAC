//
//  WTKAboutMeView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKAboutMeView : UIView

@property(nonatomic,strong)RACSubject   *clickSubject;

/**
 * 初始化
 * param titleArray 标题(1-3个)
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray<NSString *> *)titleArray;


@end
