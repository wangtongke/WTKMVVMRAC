//
//  WTKCommentCenterTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentCenterTableViewCell.h"
#import "WTKOrderModel.h"
@interface WTKCommentCenterTableViewCell ()

@property(nonatomic,strong)UIImageView  *w_goodImg;

@property(nonatomic,strong)UILabel      *w_titleLabel;

@property(nonatomic,strong)UIButton     *w_commentBtn;

@end

@implementation WTKCommentCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    WS(weakSelf);
    self.w_goodImg          = [[UIImageView alloc]init];
    self.w_goodImg.image    = [UIImage imageNamed:@"placehoder2"];
    [self addSubview:self.w_goodImg];
    [self.w_goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.left.equalTo(weakSelf).offset(10);
        make.bottom.equalTo(weakSelf).offset(-10);
        make.width.equalTo(weakSelf.w_goodImg.mas_height);
    }];
    
    self.w_titleLabel       = [[UILabel alloc]init];
    _w_titleLabel.textColor = WTKCOLOR(80, 80, 80, 1);
    _w_titleLabel.font      = [UIFont wtkNormalFont:15];
    _w_titleLabel.numberOfLines = 0;
    [self addSubview:self.w_titleLabel];
    [self.w_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(30);
        make.left.equalTo(weakSelf.w_goodImg.mas_right).offset(8);
        make.right.equalTo(weakSelf).offset(-8);
        make.bottom.equalTo(weakSelf).offset(-40);
    }];
    
    self.w_commentBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.w_commentBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
