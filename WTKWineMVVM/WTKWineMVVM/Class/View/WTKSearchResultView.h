//
//  WTKSearchResultView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKSearchViewModel;
@interface WTKSearchResultView : UIView

@property(nonatomic,strong)NSArray              *dataArray;

@property(nonatomic,strong)WTKSearchViewModel   *viewModel;

///刷新
- (void)w_reloadData;

@end
