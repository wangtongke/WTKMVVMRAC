//
//  WTKCategoryRightTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCategoryRightTableViewCell.h"
#import "WTKGoodManagerView.h"
@interface WTKCategoryRightTableViewCell ()

@property(nonatomic,strong)UIImageView          *w_imageView;
///标题
@property(nonatomic,strong)UILabel              *w_titleLabel;
///price
@property(nonatomic,strong)UILabel              *w_priceLabel;
//销量
@property(nonatomic,strong)UILabel              *w_saleCount;
///规格
@property(nonatomic,strong)UILabel              *w_specLabel;

@property(nonatomic,strong)UILabel              *w_stokeLabel;

@property(nonatomic,strong)WTKGood              *goods;

///加号减号
@property(nonatomic,strong)WTKGoodManagerView   *managerView;
@end

@implementation WTKCategoryRightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self configView];
        [self bind];
    }
    return self;
}

- (void)bind
{
    @weakify(self);
    [self.managerView.addSubject subscribeNext:^(id x) {
        @strongify(self);
        [WTKTool beginAddAnimationWithImageView:self.w_imageView animationTime:0.55 startPoint:CGPointZero endPoint:CGPointZero];
    }];
}


- (void)updateGood:(WTKGood *)goods
{
    //  检查购物车是否有商品
    if ([[WTKShoppingManager manager].goodsDic objectForKey:goods.id])
    {
        WTKGood *good = [[WTKShoppingManager manager].goodsDic objectForKey:goods.id];
        goods.num = good.num ;
    }
    else
    {
//        car没有这个商品
        goods.num = 0;
    }
    self.goods = goods;
    
    self.w_titleLabel.text      = goods.title;
    self.w_specLabel.text       = goods.specification;
    self.w_priceLabel.text      = [NSString stringWithFormat:@"¥ %.2f",goods.price];
    [self.w_imageView sd_setImageWithURL:[NSURL URLWithString:goods.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    self.w_saleCount.text       = [NSString stringWithFormat:@"已售 %d",goods.sale_count];
    [self.managerView updateGood:goods];
    if (goods.stock <= 0)
    {
        self.w_stokeLabel.hidden= NO;
        self.managerView.hidden = YES;
    }
    else
    {
        self.w_stokeLabel.hidden= YES;
        self.managerView.hidden = NO;
    }
}


- (void)configView
{
    @weakify(self);
    self.w_imageView            = [[UIImageView alloc]init];
    [self addSubview:self.w_imageView];
    [self.w_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
//    精选
    UILabel *desLabel           = [[UILabel alloc]init];
    desLabel.text               = @"精选";
    desLabel.textAlignment      = NSTextAlignmentCenter;
    desLabel.textColor          = THEME_COLOR;
    desLabel.font = [UIFont systemFontOfSize:11];
    desLabel.layer.cornerRadius = 3;
    desLabel.layer.borderColor  = desLabel.textColor.CGColor;
    desLabel.layer.borderWidth  = 0.5;
    desLabel.layer.masksToBounds = YES;
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.w_imageView).offset(2);
        make.left.equalTo(self.w_imageView.mas_right).offset(5);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(15);
    }];
    
    self.w_titleLabel           = [[UILabel alloc]init];
    _w_titleLabel.textColor     = WTKCOLOR(70, 70, 70, 1);
    _w_titleLabel.font          = [UIFont wtkNormalFont:14];
    _w_titleLabel.numberOfLines = 2;
    _w_titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_w_titleLabel sizeToFit];
    _w_titleLabel.textAlignment = NSTextAlignmentJustified;
    [self addSubview:_w_titleLabel];
    [_w_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(desLabel.mas_right).offset(1);
        make.centerY.equalTo(desLabel);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    self.w_priceLabel           = [[UILabel alloc]init];
    _w_priceLabel.textColor     = THEME_COLOR;
    _w_priceLabel.font          = [UIFont wtkNormalFont:15];
    [_w_priceLabel sizeToFit];
    [self addSubview:self.w_priceLabel];
    [self.w_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(desLabel);
        make.bottom.equalTo(self.w_imageView);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    self.w_specLabel            = [[UILabel alloc]init];
    _w_specLabel.textColor      = WTKCOLOR(150, 150, 150, 1);
    _w_specLabel.font           = [UIFont wtkNormalFont:13];
    [self addSubview:self.w_specLabel];
    [self.w_specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(desLabel);
        make.bottom.equalTo(self.w_priceLabel.mas_top);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(18);
    }];

    
    self.w_saleCount            = [[UILabel alloc]init];
    _w_saleCount.textColor      = self.w_specLabel.textColor;
    _w_saleCount.font           = self.w_specLabel.font;
    [self addSubview:self.w_saleCount];
    [self.w_saleCount mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.w_priceLabel.mas_right);
        make.centerY.equalTo(self.w_priceLabel);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    
    self.managerView            = [[WTKGoodManagerView alloc]init];
    [self addSubview:self.managerView];
    [self.managerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(110);
    }];
    
    self.w_stokeLabel           = [[UILabel alloc]init];
    _w_stokeLabel.textColor     = THEME_COLOR;
    _w_stokeLabel.font          = [UIFont wtkNormalFont:16];
    
    
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
