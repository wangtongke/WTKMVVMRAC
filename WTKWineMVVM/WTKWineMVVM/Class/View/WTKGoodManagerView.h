//
//  WTKGoodManagerView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKGood;
@interface WTKGoodManagerView : UIView


///已添加购物车数量
@property (nonatomic, assign) NSInteger num;

- (void)updateGood:(WTKGood *)good;

@end
