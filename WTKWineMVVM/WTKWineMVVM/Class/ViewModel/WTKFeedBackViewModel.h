//
//  WTKFeedBackViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKFeedBackViewModel : WTKBasedViewModel

///类型
@property(nonatomic,assign)NSInteger    *ideaType;

///提交
@property(nonatomic,strong)RACCommand   *submitConmand;

@end
