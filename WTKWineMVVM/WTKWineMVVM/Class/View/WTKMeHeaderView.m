//
//  WTKMeHeaderView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/13.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMeHeaderView.h"
#import "WTKMeViewModel.h"
@implementation WTKMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configView];
    }
    return self;
}

- (void)update
{
    if (CURRENT_USER.isLogin)
    {
        self.w_noLoginHead.hidden   = YES;
        self.w_headImage.hidden     = NO;
        self.w_phoneNum.text        = CURRENT_USER.phoneNum;
        self.w_phoneNum.hidden      = NO;
        self.w_right.hidden         = NO;
        self.w_nickNameLabel.hidden = NO;
        
        if (CURRENT_USER.headImage)
        {
            self.w_headImage.image  = CURRENT_USER.headImage;
        }
        self.w_nickNameLabel.text   = CURRENT_USER.nickName;
    }
    else
    {
        self.w_noLoginHead.hidden   = NO;
        self.w_headImage.hidden     = YES;
        self.w_phoneNum.hidden      = YES;
        self.w_right.hidden         = NO;
        self.w_nickNameLabel.hidden = YES;
        
    }
}


- (void)configView
{
    @weakify(self);
    UIImageView *bgImg          = [[UIImageView alloc]init];
    bgImg.image                 = [UIImage imageNamed:@"w_beijing"];
    [self addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.w_headImage            = [[UIImageView alloc]init];
    self.w_headImage.image      = [UIImage imageNamed:@"w_defaultHeader"];
    _w_headImage.layer.cornerRadius = 75 / 2.0;
    _w_headImage.layer.masksToBounds = YES;
    self.w_headImage.hidden     = YES;
    [self addSubview:self.w_headImage];
    [self.w_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(64);
        make.left.equalTo(self).offset(25);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(75);
    }];
    
    self.w_noLoginHead          = [[UIImageView alloc]init];
    self.w_noLoginHead.image    = [UIImage imageNamed:@"w_noLogin"];
    [self addSubview:self.w_noLoginHead];
    [self.w_noLoginHead mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.w_headImage);
        make.size.equalTo(self.w_headImage);
    }];
    
    self.w_nickNameLabel          = [[UILabel alloc]init];
    _w_nickNameLabel.textColor    = WTKCOLOR(252, 252, 252, 1);
    _w_nickNameLabel.font         = [UIFont wtkNormalFont:16];
    _w_nickNameLabel.hidden       = YES;
    [self addSubview:self.w_nickNameLabel];
    [self.w_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.w_headImage.mas_bottom).offset(-35);
        make.left.equalTo(self.w_headImage.mas_right).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    
    self.w_phoneNum             = [[UILabel alloc]init];
    _w_phoneNum.textColor       = WTKCOLOR(252, 252, 252, 1);
    _w_phoneNum.font            = [UIFont wtkNormalFont:16];
    _w_phoneNum.hidden          = YES;
    [self addSubview:self.w_phoneNum];
    [self.w_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.w_headImage.mas_right).offset(10);
        make.bottom.equalTo(self.w_headImage).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    
    _w_right                    = [[UIImageView alloc]init];
    _w_right.image              = [UIImage imageNamed:@"w_right"];
    _w_right.hidden             = YES;
    [self addSubview:_w_right];
    [_w_right mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-35);
        make.centerY.equalTo(self.w_headImage);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    UIButton *topBtn            = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.backgroundColor      = [UIColor clearColor];
    [topBtn addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.height.mas_equalTo(75);
    }];
    
    UIView *bottomBG            = [[UIView alloc]init];
    bottomBG.backgroundColor    = WTKCOLOR(70, 70, 70, 0.3);
    [self addSubview:bottomBG];
    [bottomBG mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    UIButton *leftBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor     = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBG addSubview:leftBtn];
    
    UIButton *rightBtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor    = [UIColor clearColor];
    rightBtn.tag                = 1;
    [rightBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBG addSubview:rightBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBG);
        make.left.equalTo(bottomBG);
        make.right.equalTo(rightBtn.mas_left);
        make.width.equalTo(rightBtn);
        make.height.equalTo(bottomBG);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.right.equalTo(bottomBG);
        make.top.equalTo(bottomBG);
        make.width.equalTo(leftBtn);
        make.height.equalTo(bottomBG);
    }];
    
    
    self.w_collecLabel          = [[UILabel alloc]init];
    _w_collecLabel.textColor    = WTKCOLOR(252, 252, 252, 1);
    _w_collecLabel.font         = [UIFont wtkNormalFont:14];
    _w_collecLabel.textAlignment= NSTextAlignmentCenter;
    _w_collecLabel.text         = @"0";
    [bottomBG addSubview:_w_collecLabel];
    
    self.w_historyLabel          = [[UILabel alloc]init];
    _w_historyLabel.textColor    = WTKCOLOR(252, 252, 252, 1);
    _w_historyLabel.font         = [UIFont wtkNormalFont:14];
    _w_historyLabel.textAlignment= NSTextAlignmentCenter;
    _w_historyLabel.text         = @"0";
    [bottomBG addSubview:_w_historyLabel];
    
    [_w_collecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBG).offset(3);
        make.left.equalTo(bottomBG);
        make.width.equalTo(leftBtn);
        make.height.mas_equalTo(15);
    }];
    
    [_w_historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(bottomBG);
        make.centerY.equalTo(self.w_collecLabel);
        make.width.equalTo(rightBtn);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *leftLabel          = [[UILabel alloc]init];
    leftLabel.textColor         = WTKCOLOR(252, 252, 252, 1);
    leftLabel.font              = [UIFont wtkNormalFont:14];
    leftLabel.textAlignment     = NSTextAlignmentCenter;
    leftLabel.text              = @"收藏";
    [bottomBG addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.w_collecLabel);
        make.right.equalTo(self.w_collecLabel);
        make.top.equalTo(self.w_collecLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *rightLabel         = [[UILabel alloc]init];
    rightLabel.textColor        = WTKCOLOR(252, 252, 252, 1);
    rightLabel.font             = [UIFont wtkNormalFont:14];
    rightLabel.textAlignment    = NSTextAlignmentCenter;
    rightLabel.text             = @"足迹";
    [bottomBG addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.w_historyLabel);
        make.right.equalTo(self.w_historyLabel);
        make.top.equalTo(self.w_historyLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
    }];
    
}

- (void)topBtnClick
{
    [self.viewModel.headClickSubject sendNext:@8];
}
- (void)bottomBtnClick:(UIButton *)btn
{
    [self.viewModel.headClickSubject sendNext:@(btn.tag + 9)];
}


- (void)collectBtnClick:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
