//
//  WTKShoppingCarTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKShoppingCarTableViewCell.h"
#import "WTKGoodManagerView.h"

@interface WTKShoppingCarTableViewCell ()

@property(nonatomic,strong)WTKGood *good;

@end

@implementation WTKShoppingCarTableViewCell

- (void)updateWithGood:(WTKGood *)good
{
    self.good = good;
    [self.w_managView updateGood:good];
    self.w_titleLabel.text  = good.title;
    self.w_priceLabel.text  = [NSString stringWithFormat:@"%.2f",good.price];
    UIImage *image = good.w_isSelected ? [UIImage imageNamed:@"w_pay_select"] : [UIImage imageNamed:@"w_pay_normal"];
    [self.w_selectBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.w_goodImageView sd_setImageWithURL:[NSURL URLWithString:good.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
}

- (void)setAddress:(WTKAddress *)address
{
    self.w_nameLabel.text   = address.w_name;
    self.w_phoneLabel.text  = address.w_phone;
    self.w_addressLabel.text= [NSString stringWithFormat:@"%@%@",address.w_address,address.w_detailAddress];
}
- (IBAction)selectedBtnClick:(UIButton *)sender
{
    SHOPPING_MANAGER.flag = NO;
    self.good.w_isSelected = !self.good.w_isSelected;
    SHOPPING_MANAGER.goodsDic;
    UIImage *image = self.good.w_isSelected ? [UIImage imageNamed:@"w_pay_select"] : [UIImage imageNamed:@"w_pay_normal"];
    [self.w_selectBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = WTKCOLOR(240, 240, 240, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
