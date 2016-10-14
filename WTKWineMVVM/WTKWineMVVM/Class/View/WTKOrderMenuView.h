//
//  WTKOrderMenuView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKOrderMenuView : UIView

@property(nonatomic,strong)RACSubject *clickSignal;
/**
 *  array 列表菜单(NSString *)
 */
- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)array;

- (void)dismiss;
- (void)beginAnimation;
@end
