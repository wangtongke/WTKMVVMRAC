//
//  WTKTool.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKTool.h"
#import <LocalAuthentication/LAContext.h>
#import <AVFoundation/AVFoundation.h>
#import "FXBlurView.h"
#import "WTKShareBtn.h"
#import <objc/runtime.h>

#define userTag @"user"

static 	SystemSoundID soundID=0;

@implementation WTKTool


+ (void)beginAddAnimationWithImageView:(UIImageView *)imageView
                         animationTime:(float)time
                            startPoint:(CGPoint)startP
                              endPoint:(CGPoint)endP
{
    UIWindow *window                = [[UIApplication sharedApplication].delegate window];
    CGPoint startPoint              = startP.x == 0 && startP.y == 0 ? [imageView convertPoint:imageView.center toView:window] : startP;
    CGPoint endPoint                = endP.x == 0 && endP.y == 0 ? CGPointMake(kWidth / 5.0 * 3.0 + kWidth / 10.0, kHeight - 25) : endP;
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
    
    [self playSound];
}

+ (void)playSound
{
//    NSURL *mp3URL                   = [[NSBundle mainBundle] URLForResource:@"AddShopAudio.mp3" withExtension:nil];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(mp3URL), &soundID);

    static NSURL *mp3URL            = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            mp3URL                  = [[NSBundle mainBundle] URLForResource:@"AddShopAudio.mp3" withExtension:nil];
        mp3URL = [NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"AddShopAudio" ofType:@"mp3"]];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(mp3URL), &soundID);
        });
//    AudioServicesPlayAlertSound(soundID);
    if (CURRENT_USER.isSound)
    {
        AudioServicesPlaySystemSound(soundID);
    }
    
    
    
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
                NSLog(@"%ld",error.code);
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
    else
    {
        block(@"不支持指纹验证");
    }
}

+ (void)testTouchIDWithCompleteBlock:(void (^)(BOOL))completeBlock
{
    LAContext *wtkContext           = [[LAContext alloc]init];
    
    NSError *autoError              = nil;
    
    NSString *title                 = @"请验证已有指纹，用于支付";
    //    判断设备是否支持
    
    if ([wtkContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&autoError])
    {
        [wtkContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:title reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                completeBlock(YES);
            }
            else
            {
                NSLog(@"%ld",error.code);
                // 错误码 error.code
                // -1: 连续三次指纹识别错误
                // -2: 在TouchID对话框中点击了取消按钮
                // -3: 在TouchID对话框中点击了输入密码按钮
                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                completeBlock(NO);
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

+(RACSignal *)shared
{
    RACSubject *subject     = [RACSubject subject];
//    FXBlurView *blurView    = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    blurView.tintColor      = WTKCOLOR(235, 235, 235, 0.5);
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *blurView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    UIImageView *bgImage    = [[UIImageView alloc]initWithImage:[self imageWithView:window withBlurRadiu:15]];
    bgImage.frame           = CGRectMake(0, 0, kWidth, kHeight);
    [blurView addSubview:bgImage];
    [window addSubview:blurView];
//    [UIView animateWithDuration:0.35 animations:^{
//        blurView.blurRadius = 40;
//    }];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissShareView:)];
    [blurView addGestureRecognizer:gesture];
    
    NSArray *btnImages      = @[@"sns_icon_22", @"sns_icon_23", @"sns_icon_24", @"sns_icon_6", @"sns_icon_1",@"erweima"];
    NSArray * btnTitles     = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"新浪微博",@"二维码"];
    
    CGFloat width           = kWidth / 5;
    
    CGFloat height          = width + 30;
    
    CGFloat colMargin       = kHeight / 2.0 - width;
    
    [btnImages enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        
        WTKShareBtn *btn =[WTKShareBtn button];
        [btn setFrame:CGRectMake(0.5 * width + col * (width * 1.5), colMargin + row * (height + width * 0.3) + kHeight - colMargin, width, height)];
        btn.w_imageView.image   = [UIImage imageNamed:btnImages[idx]];
        btn.w_label.text        = btnTitles[idx];
        btn.tag                 = idx + 100;
        [blurView addSubview:btn];
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"888");
            [subject sendNext:@(btn.tag)];
        }];
        
        
        [UIView animateWithDuration:1 + 0.1 * idx
                              delay:0
             usingSpringWithDamping:0.57
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [btn setFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + colMargin - kHeight, width, height)];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kWidth - 242) / 2.0, colMargin - 106 - 30 - kHeight / 2.0, 242, 106)];
    imageView.tag   = 200;
    imageView.image = [UIImage imageNamed:@"shareText"];
    [blurView addSubview:imageView];
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         imageView.frame = CGRectMake((kWidth - 242) / 2.0, colMargin - 106 - 30 , 242, 106);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
    return subject;
}

+ (void)dismissShareView:(UITapGestureRecognizer *)gesture
{
    UIView *imgView = [gesture.view viewWithTag:200];
    [UIView animateWithDuration:0.3
                     animations:^{
                         imgView.frame = CGRectMake((kWidth - 242) / 2.0, -106 - 30 , 242, 106);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    for (int i = 0 ; i < 6; i++)
    {
        UIView *view = [gesture.view viewWithTag:100 + i];
        [UIView animateWithDuration:0.4 - 0.03 * i
                         animations:^{
                             view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + kHeight  - view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             static int num = 0;
                             num++;
                             if (num == 5)
                             {
                                 [gesture.view removeFromSuperview];
                                 num = 0;
                             }
                         }];
        
    }
    
    
}
+ (UIImage *)imageWithView:(UIView *)view withBlurRadiu:(CGFloat)radiu
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height),NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img;
        
    for(UIView *subview in view.subviews)
    {
        [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
    }
    img = UIGraphicsGetImageFromCurrentImageContext();

    
    //添加毛玻璃效果
    img = [img applyBlurWithRadius:radiu tintColor:[UIColor colorWithWhite:0.8 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
    UIGraphicsEndImageContext();
    
    return img;

}

#pragma mark - 登录
+ (void)login
{
    [USER_DEFAULTS setObject:@"yidenglu" forKey:userTag];
}

+ (void)exit
{
    [USER_DEFAULTS removeObjectForKey:userTag];
}

+ (NSString *)getCacheSize
{
    return [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
}

+ (NSString *)getVersion
{
    return [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
}

+ (void)setObj:(id)toObj
       fromObj:(id)fromObj
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([toObj class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
#warning 不为空的时候赋值，防止以后添加新的类，读取时无法设置默认值
        if ([fromObj valueForKey:key])
        {
            [toObj setValue:[fromObj valueForKey:key] forKey:key];
        }
    }
}

+ (CGFloat)calculateStringHeight:(NSString *)string
                        withFont:(UIFont *)font
                     stringWidth:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width-20, 0) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

@end
