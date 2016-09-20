//
//  UIFont+WTK.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UIFont+WTK.h"

@implementation UIFont (WTK)
+(UIFont *) wtkNormalFont:(CGFloat)size;
{
    if (kWidth == 320 || kWidth == 640)
    {
        return [UIFont systemFontOfSize:size - 1];
    }
    else if (kWidth == 375 || kWidth == 750)
    {
        return [UIFont systemFontOfSize:size];
    }
    else
    {
        return [UIFont systemFontOfSize:size + 1];
    }
}

+(UIFont *) wtkBlodFont:(CGFloat)size
{
    if (kWidth == 320 || kWidth == 640)
    {
        return [UIFont boldSystemFontOfSize:size - 1];
    }
    else if (kWidth == 375 || kWidth == 750)
    {
        return [UIFont boldSystemFontOfSize:size];
    }
    else
    {
        return [UIFont boldSystemFontOfSize:size + 1];
    }
}
@end
