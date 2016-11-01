//
//  WTKSearchViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKSearchViewModel : WTKBasedViewModel

/// 搜索
@property(nonatomic,strong)RACCommand       *searchCommand;

///商品点击
@property(nonatomic,strong)RACCommand       *goodCommand;

@property(nonatomic,strong)RACCommand       *shoppingCarCommand;

///删除
@property(nonatomic,strong)RACCommand       *deleteHistory;

@property(nonatomic,weak)UIViewController *vc;

@end
