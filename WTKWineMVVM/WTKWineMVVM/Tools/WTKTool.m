//
//  WTKTool.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKTool.h"
#import <LocalAuthentication/LAContext.h>
@implementation WTKTool


+ (void)beginAddAnimationWithImageView:(UIImageView *)imageView
                         animationTime:(float)time
{
    UIWindow *window                = [[UIApplication sharedApplication].delegate window];
    CGPoint startPoint              = [imageView convertPoint:imageView.center toView:window];
    CGPoint endPoint                = CGPointMake(kWidth / 5.0 * 3.0 + kWidth / 10.0, kHeight - 25);
    __block CALayer *layer;
    layer                           = [[CALayer alloc]init];
    layer.contents                  = imageView.layer.contents;
    layer.frame                     = imageView.frame;
    layer.opacity                   = 1;
    [window.layer addSublayer:layer];
    
    UIBezierPath *path              = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    float sx                        = startPoint.x;
    float sy                        = startPoint.y;
    float ex                        = endPoint.x;
    float ey                        = endPoint.y;
    float mx                        = sx + (ex - sx) / 3.0;
    float my                        = sy + (ey - sy) * 0.5 - 400;
    
    CGPoint centerPoint             = CGPointMake(mx, my);
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
//    位置动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.path                 = path.CGPath;
    animation1.removedOnCompletion  = NO;
    
//    大小动画
    CABasicAnimation *animation2    = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    CGSize size                     = CGSizeMake(imageView.frame.size.width * 0.05, imageView.frame.size.height * 0.05);
    [animation2 setToValue:[NSValue valueWithCGSize:size]];
    
//    旋转
    CABasicAnimation *animation3    = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation3.toValue              = [NSNumber numberWithFloat:M_PI * 2.0];
    animation3.cumulative           = YES;
    animation3.duration             = 0.3;
    animation3.repeatCount          = 1000;
    
    CAAnimationGroup *group         = [[CAAnimationGroup alloc]init];
    group.animations                = @[animation1,animation2,animation3];
    group.delegate                  = self;
    group.duration                  = 0.6;
    group.removedOnCompletion       = NO;
    group.fillMode                  = kCAFillModeForwards;
    group.autoreverses              = NO;
    group.timingFunction            = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
//    添加动画
    [layer addAnimation:group forKey:@"add"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
        layer = nil;
    });
}

///注册指纹
+ (void)registTouchIDWithCompleteBlock:(void (^)(NSString *))block
{
    LAContext *wtkContext           = [[LAContext alloc]init];
    
    NSError *autoError              = nil;
    
    NSString *title                 = @"开启指纹验证";
    //    判断设备是否支持
    
    if ([wtkContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&autoError])
    {
        [wtkContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:title reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                [WTKUser currentUser].isTouchID = YES;
                block(@"验证成功");
            }
            else
            {
                NSLog(@"%d",error.code);
                // 错误码 error.code
                // -1: 连续三次指纹识别错误
                // -2: 在TouchID对话框中点击了取消按钮
                // -3: 在TouchID对话框中点击了输入密码按钮
                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                });
                
                switch (error.code)
                {
                    case -1:
                    {
                        block(@"连续三次指纹识别错误");
                    }
                        break;
                    case -2:
                    {
                        block(@"点击了取消按钮");
                        
                    }
                        break;
                    case -3:
                    {
                        block(@"点击了输入密码按钮");
                    }
                        break;
                    case -4:
                    {
                        block(@"TouchID对话框被系统取消");
                    }
                        break;
                    case -8:
                    {
                        block(@"连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码");
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }];
    }
}
///删除指纹
+ (BOOL)delegateTouchID
{
    [WTKUser currentUser].isTouchID = NO;
    return YES;
}

@end
