//
//  UITextField+WTK.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UITextField+WTK.h"



@implementation UITextField (WTK)

- (instancetype)initWithSecure
{
    self = [super init];
    if (self)
    {
        self.secureTextEntry = YES;
        [self initBtn];
    }
    return self;
}
- (void)initBtn
{
    UIButton *btn   = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 111;
    [btn setBackgroundImage:[UIImage imageNamed:@"w_textSecure1"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"w_textSecure2"] forState:UIControlStateSelected];
    [self addSubview:btn];
    @weakify(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIButton *btn = (UIButton *)[self viewWithTag:111];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(btn.frame, point))
    {
        [self btnClick:btn];
    }
}

- (void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.secureTextEntry = !self.secureTextEntry;
}


@end
