//
//  WTKCommentCenterViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
///评价中心
@interface WTKCommentCenterViewModel : WTKBasedViewModel

@property(nonatomic,strong)NSMutableArray   *dataArray;

@property(nonatomic,strong)RACCommand       *refreshCommand;

@property(nonatomic,strong)RACCommand       *cellClickCommand;

///评价
@property(nonatomic,strong)RACCommand       *commentCommand;

@end
