//
//  WTKOrderDetailViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@class WTKOrderModel;
@interface WTKOrderDetailViewModel : WTKBasedViewModel

@property(nonatomic,strong)WTKOrderModel    *order;

@property(nonatomic,strong)RACSubject       *segmentSubject;

@property(nonatomic,strong)RACCommand       *requestStatusCommand;

@property(nonatomic,strong)NSMutableArray   *statusArray;

/**刷新detailTableView*/
@property(nonatomic,strong)RACCommand       *refreshDetail;

/**刷新statusTableView*/
@property(nonatomic,strong)RACCommand       *refreshStatus;
@end
