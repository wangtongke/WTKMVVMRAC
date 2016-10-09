//
//  WTKShareBtn.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/9.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKShareBtn.h"

@implementation WTKShareBtn

+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.w_imageView)
    {
        return;
    }
    @weakify(self);
    self.w_imageView = [[UIImageView alloc]init];
    [self addSubview:self.w_imageView];
    [self.w_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self.mas_width);
    }];
    
    self.w_label                = [[UILabel alloc]init];
    self.w_label.textAlignment  = NSTextAlignmentCenter;
    self.w_label.textColor      = WTKCOLOR(70, 70, 70, 1);
    self.w_label.font           = [UIFont wtkNormalFont:14];
    [self addSubview:self.w_label];
    
    [self.w_label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.w_imageView.mas_bottom).offset(5);
        make.left.equalTo(self.w_imageView).offset(-5);
        make.right.equalTo(self.w_imageView).offset(5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
