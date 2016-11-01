//
//  WTKHomeCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKHomeCell : UICollectionViewCell

///是否为搜索界面的cell(标志是否做动画)
@property(nonatomic,assign)BOOL isSearch;

- (void)updateGood:(WTKGood *)goods;

@end
