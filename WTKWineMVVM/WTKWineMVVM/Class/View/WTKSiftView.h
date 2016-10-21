//
//  WTKSiftView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  分类筛选视图
 */
@interface WTKSiftView : UIView

@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong)RACSubject *dismissSubject;

///刷新数据
- (void)reloadData;

///移除
- (void)dismiss;

@end
