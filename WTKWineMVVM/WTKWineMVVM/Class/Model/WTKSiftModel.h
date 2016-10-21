//
//  WTKSiftModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKSiftModel : NSObject

@property(nonatomic,copy)NSString *_id;

@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *end_price;
@property(nonatomic,copy)NSString *mobile_category_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *order;
@property(nonatomic,copy)NSString *start_price;
@property(nonatomic,copy)NSString *subtype;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *updated_at;
@property(nonatomic,copy)NSString *userinfo_id;

@property(nonatomic,assign)BOOL   isSelected;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
