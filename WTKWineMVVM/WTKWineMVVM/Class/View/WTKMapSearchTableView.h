//
//  WTKMapSearchTableView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/28.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKMapViewModel;
@interface WTKMapSearchTableView : UITableView

@property(nonatomic,strong)NSArray *searchArray;

@property(nonatomic,strong)WTKMapViewModel *viewModel;

@end
