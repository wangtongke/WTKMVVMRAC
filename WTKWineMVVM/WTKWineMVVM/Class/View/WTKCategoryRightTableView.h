//
//  WTKCategoryRightTableView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKCategoryViewModel;
@interface WTKCategoryRightTableView : UITableView

@property(nonatomic,strong)NSArray                  *sectionArray;

@property(nonatomic,strong)NSDictionary             *dataDic;

@property(nonatomic,strong)WTKCategoryViewModel     *viewModel;

@end
