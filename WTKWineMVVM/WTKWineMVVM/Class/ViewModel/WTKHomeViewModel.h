//
//  WTKHomeViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKHomeViewModel : WTKBasedViewModel
/**刷新数据*/
@property(nonatomic,strong)RACCommand   *refreshCommand;

@property(nonatomic,strong)NSArray      *headData;

@property(nonatomic,strong)NSArray      *dataArray;

///头视图
@property(nonatomic,strong)RACCommand   *headCommand;

///中间按钮点击
@property(nonatomic,strong)RACCommand   *btnCommand;

///good
@property(nonatomic,strong)RACCommand   *goodCommand;

///导航栏
@property(nonatomic,strong)RACCommand   *naviCommand;

@property(nonatomic,strong)RACSubject   *searchSubject;

@end
