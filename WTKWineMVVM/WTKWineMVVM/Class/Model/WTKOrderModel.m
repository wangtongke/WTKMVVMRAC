//
//  WTKOrderModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderModel.h"
#import "WTKOrderDetailModel.h"
@implementation WTKOrderModel

- (instancetype)initWithDic:(NSDictionary *)aDic
{
    self = [super init];
    if (self)
    {
        for (NSString *key in [aDic allKeys])
        {
            if ([key isEqualToString:@"ordergoods"])
            {
                NSArray *array = aDic[@"ordergoods"];
                NSMutableArray *mArray = @[].mutableCopy;
                for (NSDictionary *aDic in array)
                {
                    WTKOrderDetailModel *model = [[WTKOrderDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:aDic];
                    [mArray addObject:model];
                }
                self.ordergoods = mArray;
                
            }
            else
            {
                [self setValue:aDic[key] forKey:key];
            }
            
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
