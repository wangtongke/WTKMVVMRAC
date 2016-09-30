//
//  WTKTouchManager.m
//  WTKTransitionAnimation
//
//  Created by 王同科 on 16/9/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKTouchManager.h"

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width
@implementation WTKTouchManager

+ (instancetype)shareManager
{
    static WTKTouchManager *manaager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manaager = [[WTKTouchManager alloc]init];
        manaager.touchPoint = CGPointMake(0, 0);
    });
    return manaager;

}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
}

- (float)radius
{
    float maxRadiu      = 0;
    CGPoint point1      = CGPointMake(0, 0);
    CGPoint point2      = CGPointMake(kWidth, 0);
    CGPoint point3      = CGPointMake(0, kHeight);
    CGPoint point4      = CGPointMake(kWidth, kHeight);
    NSArray *array      = @[[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3],[NSValue valueWithCGPoint:point4]];

    for (NSValue *value in array)
    {
        CGPoint point   = value.CGPointValue;
        float x         = point.x - self.touchPoint.x;
        float y         = point.y - self.touchPoint.y;
        maxRadiu        = maxRadiu > sqrtf(x * x + y * y) ? maxRadiu : sqrtf(x * x + y * y);
    }

    return maxRadiu;
}

@end
