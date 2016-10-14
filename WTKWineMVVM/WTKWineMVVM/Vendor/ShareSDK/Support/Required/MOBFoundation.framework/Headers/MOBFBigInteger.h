//
//  MOBFBigInteger.h
//  MOBFoundation
//
//  Created by fenghj on 15/7/14.
//  Copyright (c) 2015年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOBFQuotientAndReminder;

/**
 *  大数
 */
@interface MOBFBigInteger : NSObject <NSCoding>

/**
 *  初始化大数对象
 *
 *  @return 大数对象
 */
- (instancetype)init;

/**
 *  初始化大数对象
 *
 *  @param value 整型数据
 *
 *  @return 大数对象
 */
- (instancetype)initWithInt:(NSInteger)value;

/**
 *  初始化大数对象
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (instancetype)initWithBigInteger:(MOBFBigInteger *)value;

/**
 *  初始化大数对象
 *
 *  @param valueString 数值字符串
 *
 *  @return 大数对象
 */
- (instancetype)initWithString:(NSString *)valueString;

/**
 *  初始化大数对象
 *
 *  @param valueString 数值字符串
 *  @param radix       进制
 *
 *  @return 大数对象
 */
- (instancetype)initWithString:(NSString *)valueString radix:(int)radix;

/**
 *  初始化大数对象
 *
 *  @param bits 大素数位数
 *
 *  @return 大数对象
 */
- (instancetype)initWithRandomPremeBits:(int)bits;

/**
 *  初始化大数对象
 *
 *  @param bytes 字节流
 *  @param size  长度
 *
 *  @return 大数对象
 */
- (instancetype)initWithBytes:(const void *)bytes size:(int)size;

/**
 *  初始化大数对象
 *
 *  @param bytes 无符号字节流
 *  @param size  长度
 *
 *  @return 大数对象
 */
- (instancetype)initWithUnsignedBytes:(const void *)bytes size:(int)size;

/**
 *  大数相加
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)addByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数相加
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)addByInteger:(NSInteger)value;

/**
 *  大数相减
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)subByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数相减
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)subByInteger:(NSInteger)value;

/**
 *  大数相乘
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)multiplyByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数相乘
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)multiplyByInteger:(NSInteger)value;

/**
 *  大数相除并得出余数
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFQuotientAndReminder *)divideAndReminderByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数相除并得出余数
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFQuotientAndReminder *)divideAndReminderByInteger:(NSInteger)value;

/**
 *  大数相除
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)divideByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数相除
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)divideByInteger:(NSInteger)value;

/**
 *  大数求余
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)reminderByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数求余
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)reminderByInteger:(NSInteger)value;

/**
 *  大数幂运算
 *
 *  @param exponent 指数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)pow:(NSUInteger)exponent;

/**
 *  大数幂运算求余
 *
 *  @param exponent 指数
 *  @param value    模数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)pow:(MOBFBigInteger *)exponent mod:(MOBFBigInteger *)value;

/**
 *  大数求反
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)negate;

/**
 *  大数绝对值
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)abs;

/**
 *  大数位异或
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseXorByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数位异或
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseXorByInteger:(NSInteger)value;

/**
 *  大数或
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseOrByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数或
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseOrByInteger:(NSInteger)value;

/**
 *  大数与
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseAndByBigInteger:(MOBFBigInteger *)value;

/**
 *  大数与
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)bitwiseAndByInteger:(NSInteger)value;

/**
 *  左移
 *
 *  @param placesToShift 左移位数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)shiftLeft:(int)placesToShift;

/**
 *  右移
 *
 *  @param placesToShift 右移位数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)shiftRight:(int)placesToShift;

/**
 *  最大公约数
 *
 *  @param value 大数对象
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)gcdByBigInteger:(MOBFBigInteger *)value;

/**
 *  最大公约数
 *
 *  @param value 整数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)gcdByInteger:(NSInteger)value;

/**
 *  大数求余逆
 *
 *  @param n 阶数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)modInverseByBigInteger:(MOBFBigInteger *)n;

/**
 *  大数求余逆
 *
 *  @param n 阶数
 *
 *  @return 大数对象
 */
- (MOBFBigInteger *)modInverseByInteger:(NSInteger)n;

/**
 *  比较
 *
 *  @param value 大数对象
 *
 *  @return 比较结果
 */
- (NSComparisonResult)compare:(MOBFBigInteger *)value;

/**
 *  转换为字符串
 *
 *  @return 数值字符串
 */
- (NSString *)toString;

/**
 *  转换为字符串
 *
 *  @param radix 进制
 *
 *  @return 字符串
 */
- (NSString *)toString:(int)radix;

/**
 *  转换为整型
 *
 *  @return 整数
 */
- (NSInteger)toInteger;

/**
 *  获取字节流
 *
 *  @param bytes  字节流
 *  @param length 长度
 */
- (void)getBytes:(void **)bytes length:(int *)length;

/**
 *  获取无符号字节流
 *
 *  @param bytes  字节流
 *  @param length 长度
 */
- (void)getUnsignBytes:(void **)bytes length:(int *)length;

/**
 *  获取1常量
 *
 *  @return 大数对象
 */
+ (MOBFBigInteger *)one;

@end
