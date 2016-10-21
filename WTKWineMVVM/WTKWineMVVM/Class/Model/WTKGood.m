//
//  WTKGood.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGood.h"
#import <objc/runtime.h>

@implementation WTKGood

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
//            NSString *urlString = [NSString stringWithFormat:@"%@/userinfos/%@/products/%@/desc",JK_IMAGE_URL,bid,self.goods.id];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([WTKGood class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
        if ([aDecoder decodeObjectForKey:key])
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i ++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key  = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    [aCoder encodeObject:@(NO) forKey:@"w_isSelected"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title:%@--isSelected:%d---num:%ld--price:%.2f",self.title,self.w_isSelected,self.num,self.price];
}

@end
