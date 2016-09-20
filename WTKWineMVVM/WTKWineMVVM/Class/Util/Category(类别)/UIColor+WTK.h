//
//  UIColor+WTK.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WTK)
/**
 * 十六进制颜色值
 */
+(UIColor *) colorWithHex:(long)hex;
+(UIColor *) colorWithHexString:(NSString *)hex;

+(UIColor *) colorWithHex:(long)hex alpha:(float)alpha;
@end
