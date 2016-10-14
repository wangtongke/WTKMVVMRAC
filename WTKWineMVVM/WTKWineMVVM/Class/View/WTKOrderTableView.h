//
//  WTKOrderTableView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTKOrderViewModel;
@interface WTKOrderTableView : UITableView

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)WTKOrderViewModel *viewModel;

@end
