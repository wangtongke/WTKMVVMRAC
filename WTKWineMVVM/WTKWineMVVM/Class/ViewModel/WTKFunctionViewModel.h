//
//  WTKFunctionViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKFunctionViewModel : WTKBasedViewModel

@property(nonatomic,strong)RACCommand       *switchCommand;

@end
