//
//  WTKTouchID.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKTouchID.h"
#import <LocalAuthentication/LAContext.h>

@implementation WTKTouchID

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

+ (BOOL)delegateTouchID
{
    [WTKUser currentUser].isTouchID = NO;
    return YES;
}

@end
