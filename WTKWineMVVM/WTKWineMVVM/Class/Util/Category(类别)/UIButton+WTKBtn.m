//
//  UIButton+WTKBtn.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UIButton+WTKBtn.h"


@implementation UIButton (WTKBtn)

+ (instancetype)createCustomButtonWithFrame:(CGRect)frame title:(NSString *)title backGroungColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)titleFont
{
    UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame               = frame;
    btn.titleLabel.font     = titleFont;
    btn.backgroundColor     = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    return btn;
}


@end
