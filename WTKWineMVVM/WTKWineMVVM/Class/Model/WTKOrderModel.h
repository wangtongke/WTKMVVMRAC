//
//  WTKOrderModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKOrderModel : NSObject

/**
 *  id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  收货人
 */
@property (nonatomic, copy) NSString *consignee;

/**
 *  订单时间
 */
@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *customer_id;

@property (nonatomic, copy) NSString *fright;

/**
 *  价格
 */
@property (nonatomic, copy) NSString *goodsvalue;

/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *orderno;

@property (nonatomic, copy) NSString *ordertype;

/**
 *  支付价格
 */
@property (nonatomic, assign) float paycost;

/**
 *  支付类型
 */
@property (nonatomic, copy) NSString *paymode;

/**
 *  手机号
 */
@property (nonatomic, copy) NSString *telephone;

/**
 *  总价格
 */
@property (nonatomic, copy) NSString *totalcost;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *useintegral;

/**
 * 订单状态
 */
@property (nonatomic, copy) NSString *workflow_state;

//@property (nonatomic, strong) NSArray *ordergoodcompleteds;
/**
 * 商品数组
 */
@property (nonatomic, strong) NSArray *ordergoods;

- (instancetype)initWithDic:(NSDictionary *)aDic;
@end
