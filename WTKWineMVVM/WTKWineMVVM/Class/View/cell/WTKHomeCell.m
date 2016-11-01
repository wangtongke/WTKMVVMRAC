//
//  WTKHomeCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeCell.h"
#import "WTKGoodManagerView.h"
@interface WTKHomeCell ()

///商品
@property(nonatomic,strong)UIImageView  *wtkImageView;

///标题
@property(nonatomic,strong)UILabel      *wtkTitleLabel;

@property(nonatomic,strong)UILabel      *wtkDescLabel;

@property(nonatomic,strong)UILabel      *wtkPriceLabel;

///无货
@property(nonatomic,strong)UILabel      *wtkStockLabel;

@property(nonatomic,strong)WTKGood      *goods;

///加号减号
@property(nonatomic,strong)WTKGoodManagerView *managerView;



@end

@implementation WTKHomeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor redColor];
        [self configView];
        [self bind];
    }
    return self;
}



- (void)bind
{

    @weakify(self);
    [RACObserve(self.managerView, num) subscribeNext:^(id x) {
//        NSLog(@"%@",x);
    }];
    
    [self.managerView.addSubject subscribeNext:^(id x) {
        @strongify(self);
        if(!self.isSearch)
        {
            [WTKTool beginAddAnimationWithImageView:self.wtkImageView animationTime:0.55 startPoint:CGPointZero endPoint:CGPointZero];
        }
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
    self.wtkTitleLabel.text = goods.title;
    self.wtkPriceLabel.text = [NSString stringWithFormat:@"%.2f",goods.price];
    
    [self.wtkImageView sd_setImageWithURL:[NSURL URLWithString:goods.thumb_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    if (goods.stock <= 0)
    {
        self.wtkStockLabel.hidden   = NO;
        self.managerView.hidden     = YES;
    }
    else
    {
        self.wtkStockLabel.hidden   = YES;
        self.managerView.hidden     = NO;
        [self.managerView updateGood:goods];
    }
    
}


- (void)configView
{
    CGFloat width = self.bounds.size.width;
    WS(weakSelf);
    UIView *bgView                  = [[UIView alloc]init];
    bgView.backgroundColor          = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.equalTo(weakSelf);
    }];
    
    self.wtkImageView               = [[UIImageView alloc]init];
    [bgView addSubview:self.wtkImageView];
    [self.wtkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.top.equalTo(bgView);
        make.width.equalTo(bgView);
        make.height.equalTo(bgView.mas_width);
    }];
    
    self.wtkTitleLabel              = [[UILabel alloc]init];
    _wtkTitleLabel.font             = [UIFont wtkNormalFont:15];
    _wtkTitleLabel.textColor        = WTKCOLOR(40, 40, 40, 1);
    [bgView addSubview:self.wtkTitleLabel];
    [_wtkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(2);
        make.top.equalTo(weakSelf.wtkImageView.mas_bottom).offset(5);
        make.width.mas_equalTo(width - 4);
        make.height.equalTo(@15);
    }];
    
    self.wtkDescLabel               = [[UILabel alloc]init];
    _wtkDescLabel.textAlignment     = NSTextAlignmentCenter;
    _wtkDescLabel.font              = [UIFont wtkNormalFont:10];
    _wtkDescLabel.textColor         = THEME_COLOR;
    _wtkDescLabel.layer.borderColor = THEME_COLOR.CGColor;
    _wtkDescLabel.layer.borderWidth = 0.3;
    _wtkDescLabel.layer.cornerRadius    = 3;
    _wtkDescLabel.layer.masksToBounds   = YES;
    _wtkDescLabel.text = @"精选";
    [bgView addSubview:self.wtkDescLabel];
    
    [_wtkDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(2);
        make.top.equalTo(weakSelf.wtkTitleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(30 * ZOOM_SCALL);
        make.height.mas_equalTo(15);
    }];
    
    self.wtkPriceLabel              = [[UILabel alloc]init];
    _wtkPriceLabel.font             = [UIFont wtkNormalFont:14];
    _wtkPriceLabel.textColor        = THEME_COLOR;
    _wtkPriceLabel.text             = @"¥135.00";
    [bgView addSubview:_wtkPriceLabel];
    [_wtkPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(1);
        make.top.equalTo(weakSelf.wtkDescLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(100 * ZOOM_SCALL);
        make.height.equalTo(@15);
    }];
    
    self.managerView                = [[WTKGoodManagerView alloc]init];
    [bgView addSubview:self.managerView];
    [self.managerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(0);
        make.bottom.equalTo(bgView.mas_bottom).offset(-10);
        make.width.mas_equalTo(110);
        make.height.equalTo(@40);
    }];
    
    self.wtkStockLabel              = [[UILabel alloc]init];
    self.wtkStockLabel.font         = [UIFont wtkNormalFont:17];
    self.wtkStockLabel.text         = @"补货中";
    self.wtkStockLabel.textColor    = THEME_COLOR;
    _wtkStockLabel.textAlignment    = NSTextAlignmentCenter;
    [bgView addSubview:_wtkStockLabel];
    [_wtkStockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.managerView);
        make.right.equalTo(weakSelf.managerView);
        make.size.equalTo(weakSelf.managerView);
    }];
}


@end
