//
//  WTKShoppingManager.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKShoppingManager : NSObject<NSCoding>

///商品
@property(nonatomic,strong)NSMutableDictionary  *goodsDic;

///记录购物车改变
@property(nonatomic,copy)NSString               *changed;

///标志是添加至购物车还是监听  NO-ADD
@property(nonatomic,assign)BOOL                 flag;

@property(nonatomic,strong)UIView               *view;

///当前购物车已选择的总价
@property(nonatomic,assign)CGFloat               price;

+ (instancetype)manager;

///刷新购物车物品（删除已经购买的）
- (void)refreshGoods;

@end
