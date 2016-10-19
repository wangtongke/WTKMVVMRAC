//
//  WTKDropView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKDropView : UIView
/**
 *  下拉菜单
 */

/**
*   点击
*/
@property(nonatomic,strong)RACSubject *clickSubject;

@property(nonatomic,strong)RACSubject *dismissSubject;

/**
 *  设置背景图片
 */
@property(nonatomic,strong)UIImage *image;

/**
 *  构建方法
 *  param array   标题
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray<NSString *> *)array;
/**
 *  移除
 */
- (void)dismiss;

/**
 *  添加之后做动画
 */
- (void)beginAnimation;
@end
