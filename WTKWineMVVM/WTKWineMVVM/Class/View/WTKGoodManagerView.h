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

/// 添加到购物车
@property(nonatomic,strong)RACSubject   *addSubject;

///移除时发送信号
@property(nonatomic,strong)RACSubject   *reduceSubject;

- (void)updateGood:(WTKGood *)good;

@end
