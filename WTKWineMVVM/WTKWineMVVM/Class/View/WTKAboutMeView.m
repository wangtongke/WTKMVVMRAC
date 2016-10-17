//
//  WTKAboutMeView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAboutMeView.h"

@interface WTKAboutMeView ()

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)CGRect   bgFrame;

@end

@implementation WTKAboutMeView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray<NSString *> *)array
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    if (self)
    {
        self.titleArray = array;
        self.bgFrame    = frame;
        self.clickSubject = [RACSubject subject];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIImageView *bgImageView    = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgImageView.image           = [WTKTool imageWithView:[[UIApplication sharedApplication].delegate window] withBlurRadiu:5];
    [self addSubview:bgImageView];
    
    UIView *bgView              = [[UIView alloc]initWithFrame:self.bgFrame];
    bgView.layer.borderWidth    = 0.7;
    bgView.layer.borderColor    = WTKCOLOR(180, 180, 180, 1).CGColor;
    bgView.layer.cornerRadius   = 5;
    bgView.layer.masksToBounds  = YES;
    [self addSubview:bgView];
    UIImageView *imageView      = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bgFrame.size.width, self.bgFrame.size.width)];
    imageView.image             = [UIImage imageNamed:@"w_weixinerweima"];
    [bgView addSubview:imageView];
    
    NSInteger count             = self.titleArray.count;
    CGFloat width               = self.bgFrame.size.width / count - 0.3 * (count + 1);
    CGFloat height              = 30;
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag                 = idx;
        btn.frame               = CGRectMake(0.3 + (width + 0.3) * idx, self.bgFrame.size.height - 30.3, width, height);
        btn.backgroundColor     = [UIColor whiteColor];
        btn.titleLabel.font     = [UIFont wtkNormalFont:16];
        btn.layer.cornerRadius  = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor   = THEME_COLOR.CGColor;
        btn.layer.borderWidth   = 0.3;
        [bgView addSubview:btn];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:WTKCOLOR(70, 70, 70, 1) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}
- (void)btnClick:(UIButton *)btn
{
    [self.clickSubject sendNext:@(btn.tag)];
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
