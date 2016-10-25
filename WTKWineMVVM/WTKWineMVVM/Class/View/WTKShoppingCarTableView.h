//
//  WTKShoppingCarTableView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKShoppingCarViewModel;
@interface WTKShoppingCarTableView : UITableView

@property(nonatomic,strong)NSArray                  *dataArray;

@property(nonatomic,strong)WTKShoppingCarViewModel  *viewModel;


- (void)w_reloadData;
@end
