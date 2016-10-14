//
//  WTKOrderStateTableView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTKOrderModel;

@interface WTKOrderStateTableView : UITableView

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)WTKOrderModel *order;


@end
