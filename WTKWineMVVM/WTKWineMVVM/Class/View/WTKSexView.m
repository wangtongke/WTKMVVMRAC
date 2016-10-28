//
//  WTKSexView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSexView.h"

@interface WTKSexView ()

@property(nonatomic,strong)UIImageView *leftImg;

@property(nonatomic,strong)UIImageView *rightImg;

@end

@implementation WTKSexView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.subject = [RACSubject subject];
        self.w_sex = YES;
        [self initView];
    }
    return self;
}
- (void)initView
{
    @weakify(self);
    UIView *leftBG          = [[UIView alloc]init];
    [self addSubview:leftBG];
    
    UIView *rightBG         = [[UIView alloc]init];
    [self addSubview:rightBG];
    
    [leftBG mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(rightBG.mas_left);
        make.height.equalTo(self);
        make.width.equalTo(rightBG);
    }];
    [rightBG mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(leftBG.mas_right);
        make.height.equalTo(self);
        make.width.equalTo(leftBG);
        make.right.equalTo(self);
    }];
    
    self.leftImg            = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_pay_select"]];
    [leftBG addSubview:self.leftImg];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBG).offset(5);
        make.centerY.equalTo(leftBG);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *leftLabel      = [[UILabel alloc]init];
    leftLabel.text          = @"先生";
    leftLabel.font          = [UIFont wtkNormalFont:15];
    leftLabel.textColor     = WTKCOLOR(70, 70, 70, 1);
    [leftBG addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.leftImg.mas_right).offset(5);
        make.top.equalTo(leftBG);
        make.bottom.equalTo(leftBG);
        make.right.equalTo(leftBG);
    }];
    
    self.rightImg           = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_pay_normal"]];
    [rightBG addSubview:self.rightImg];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightBG).offset(5);
        make.centerY.equalTo(rightBG);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *rightLabel     = [[UILabel alloc]init];
    rightLabel.text         = @"女士";
    rightLabel.font         = [UIFont wtkNormalFont:15];
    rightLabel.textColor    = WTKCOLOR(70, 70, 70, 1);
    [rightBG addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.rightImg.mas_right).offset(5);
        make.top.equalTo(rightBG);
        make.bottom.equalTo(rightBG);
        make.right.equalTo(rightBG);
    }];
    
    UIButton *leftBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBG addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(leftBG);
        make.size.equalTo(leftBG);
    }];
    
    UIButton *rightBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBG addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(rightBG);
        make.size.equalTo(rightBG);
    }];
}

- (void)leftBtnClick
{
    self.leftImg.image      = [UIImage imageNamed:@"w_pay_select"];
    self.rightImg.image     = [UIImage imageNamed:@"w_pay_normal"];
    [self.subject sendNext:@1];
    _w_sex              = YES;
}
- (void)rightBtnClick
{
    self.leftImg.image      = [UIImage imageNamed:@"w_pay_normal"];
    self.rightImg.image     = [UIImage imageNamed:@"w_pay_select"];
    [self.subject sendNext:@0];
    _w_sex              = NO;
}
- (void)setW_sex:(BOOL)w_sex
{
    _w_sex = w_sex;
    if (w_sex)
    {
        [self leftBtnClick];
    }
    else
    {
        [self rightBtnClick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
