//
//  WTKCommentBtn.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/2.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentBtn.h"

@interface WTKCommentBtn ()

@property(nonatomic,strong)UILabel  *w_titleLabel;

@property(nonatomic,strong)UILabel  *w_subLabel;

@end

@implementation WTKCommentBtn

+ (instancetype)buttonWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    WTKCommentBtn *btn = [WTKCommentBtn buttonWithType:UIButtonTypeCustom];
    [btn initViewWithTitle:title subTitle:subTitle];
    btn.backgroundColor             = [UIColor whiteColor];
    return btn;
}

- (void)setW_titleColor:(UIColor *)w_titleColor
{
    _w_titleColor                   = w_titleColor;
    self.w_titleLabel.textColor     = w_titleColor;
    self.w_subLabel.textColor       = w_titleColor;
}
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.w_titleLabel.text          = title;
    self.w_subLabel.text            = subTitle;
}

- (void)initViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    WS(weakSelf);
    self.w_titleLabel               = [[UILabel alloc]init];
    self.w_titleLabel.textColor     = WTKCOLOR(80, 80, 80, 1);
    self.w_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.w_titleLabel.font          = [UIFont wtkNormalFont:15];
    self.w_titleLabel.text          = title;
    [self addSubview:self.w_titleLabel];
    [self.w_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(weakSelf);
        make.height.mas_equalTo(22);
    }];
    
    self.w_subLabel                 = [[UILabel alloc]init];
    self.w_subLabel.textColor       = WTKCOLOR(80, 80, 80, 1);
    self.w_subLabel.textAlignment   = NSTextAlignmentCenter;
    self.w_subLabel.font            = [UIFont wtkNormalFont:14];
    self.w_subLabel.text            = subTitle;
    [self addSubview:self.w_subLabel];
    [self.w_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.height.mas_equalTo(22);
    }];

}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    self.w_titleLabel.frame = CGRectMake(0, 3, frame.size.width, 22);
//    self.w_subLabel.frame   = CGRectMake(0, frame.size.height / 2.0 , frame.size.width, 22);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
