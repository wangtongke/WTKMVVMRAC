//
//  WTKGoodsViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
@class WTKGood;
@interface WTKGoodsViewModel : WTKBasedViewModel
@property(nonatomic,strong)WTKGood      *goods;

@property(nonatomic,strong)RACCommand   *addCommand;

@property(nonatomic,strong)RACCommand   *clickShopCommand;
///分享
@property(nonatomic,strong)RACCommand *shareCommand;

@end
