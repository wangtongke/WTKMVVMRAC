//
//  WTKOrderViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKOrderViewModel : WTKBasedViewModel

@property(nonatomic,strong)NSMutableArray   *array;

@property(nonatomic,strong)RACCommand       *refreshCommand;

@property(nonatomic,strong)RACSubject       *menuClickSignal;

@property(nonatomic,strong)RACCommand       *cellClickCommand;

@property(nonatomic,assign)NSInteger        orderType;
@end
