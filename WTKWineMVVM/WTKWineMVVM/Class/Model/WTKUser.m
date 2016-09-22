//
//  WTKUser.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKUser.h"
#import <objc/runtime.h>
@implementation WTKUser

+ (instancetype)currentUser
{
    static WTKUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[WTKUser alloc]init];
        user.bageValue = 0;
    });
    return user;
}
- (void)setBageValue:(NSInteger)bageValue
{
    _bageValue = bageValue;
    if (bageValue <= 0)
    {
        _bageValue = 0;
    }
}


//实现归档解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (int i = 0 ; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
        [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
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
}

@end
