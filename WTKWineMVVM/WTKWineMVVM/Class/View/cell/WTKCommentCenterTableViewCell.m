//
//  WTKCommentCenterTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentCenterTableViewCell.h"
#import "WTKOrderModel.h"
#import "WTKOrderDetailModel.h"
@interface WTKCommentCenterTableViewCell ()

@property(nonatomic,strong)UIImageView  *w_goodImg;

@property(nonatomic,strong)UILabel      *w_titleLabel;

@property(nonatomic,strong)UIButton     *w_commentBtn;

@property(nonatomic,strong)WTKOrderModel *w_order;

@end

@implementation WTKCommentCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.commentSubject = [RACSubject subject];
        [self initView];
    }
    return self;
}

- (void)updateWithOrder:(WTKOrderModel *)order
{
    WS(weakSelf);
    self.w_order = order;
    if (order.ordergoods.count > 0)
    {
        WTKOrderDetailModel *model = order.ordergoods.firstObject;
        [self.w_goodImg sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
        [order.ordergoods enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTKOrderDetailModel *detail = obj;
            weakSelf.w_titleLabel.text = [NSString stringWithFormat:@"%@、%@",weakSelf.w_titleLabel.text,detail.title];
        }];
    }
}
- (void)commentBtnClick
{
    [self.commentSubject sendNext:self.w_order];
//    [self.commentSubject sendCompleted];
}

- (void)initView
{
    self.selectionStyle     = UITableViewCellSelectionStyleNone;
    WS(weakSelf);
    self.w_goodImg          = [[UIImageView alloc]init];
    self.w_goodImg.image    = [UIImage imageNamed:@"placehoder2"];
    self.w_goodImg.layer.borderColor = WTKCOLOR(222, 222, 222, 0.8).CGColor;
    self.w_goodImg.layer.borderWidth = 0.4;
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
    self.w_commentBtn.titleLabel.font   = [UIFont wtkNormalFont:13];
    self.w_commentBtn.layer.cornerRadius = 5;
    self.w_commentBtn.layer.masksToBounds = YES;
    self.w_commentBtn.layer.borderColor = THEME_COLOR.CGColor;
    self.w_commentBtn.layer.borderWidth = 0.3;
    [self.w_commentBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
    [self addSubview:self.w_commentBtn];
    [self.w_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.w_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-10);
        make.right.equalTo(weakSelf).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    UIView *line            = [[UIView alloc]init];
    line.backgroundColor    = WTKCOLOR(199, 199, 199, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-0.7);
        make.height.mas_equalTo(0.7);
    }];

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
