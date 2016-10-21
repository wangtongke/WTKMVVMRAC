//
//  WTKSiftModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSiftModel.h"

@implementation WTKSiftModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        for (NSString *key in [dic allKeys])
        {
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}

@end
