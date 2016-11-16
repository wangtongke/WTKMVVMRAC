//
//  WTKOrderTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderTableViewCell.h"
#import "WTKOrderModel.h"
#import "WTKOrderDetailModel.h"

@interface WTKOrderTableViewCell ()

@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation WTKOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrder:(WTKOrderModel *)order
{
    _order = order;

    self.w_timeLabel.text       = order.created_at;
    self.w_statusButton.hidden  = YES;
    self.w_finishImage.hidden   = YES;
    if ([order.workflow_state isEqualToString:@"generation"])
    {
//        待付款
        self.w_statusLabel.text                 = @"待付款";
        self.w_statusButton.hidden              = NO;
        self.w_statusButton.layer.cornerRadius  = 5;
        self.w_statusButton.layer.masksToBounds = YES;
        self.w_statusButton.layer.borderColor   = THEME_COLOR.CGColor;
        self.w_statusButton.layer.borderWidth   = 0.3;
        [self.w_statusButton setTitle:@"去付款" forState:UIControlStateNormal];
    }
    else if ([order.workflow_state isEqualToString:@"cancelled"])
    {
//        已取消
        self.w_statusLabel.text                 = @"已取消";
    }
    else if ([order.workflow_state isEqualToString:@"paid"])
    {
//        待接单
        self.w_statusLabel.text                 = @"待接单";
    }
    else if ([order.workflow_state isEqualToString:@"distribution"] || [order.workflow_state isEqualToString:@"take"])
    {
//        配送中
        self.w_statusLabel.text                 = @"配送中";
    }
    else if ([order.workflow_state isEqualToString:@"completed"])
    {
//        已完成
        self.w_statusLabel.text                 = @"已完成";
        self.w_finishImage.hidden               = NO;
    }
    else if ([order.workflow_state isEqualToString:@"receive"])
    {
//        已配送
        self.w_statusLabel.text                 = @"已配送";
    }
    
    self.w_statusLabel.layer.cornerRadius       = 5;
    self.w_statusLabel.layer.masksToBounds      = YES;
    self.w_statusLabel.layer.borderColor        = THEME_COLOR.CGColor;
    self.w_statusLabel.layer.borderWidth        = 0.3;
    
//    图片
    [self setGoodImage];
    self.w_priceLabel.text                      = [NSString stringWithFormat:@"%.2f",order.paycost];
    
}

/**
 *  设置scrollview的中图片
 */
- (void)setGoodImage
{
    for (UIView *view in self.imageArray) {
        [view removeFromSuperview];
    }
    self.w_scrollView.userInteractionEnabled = NO;

    NSArray *array = self.order.ordergoods;
    _w_scrollView.showsHorizontalScrollIndicator = NO;
    
    if (array.count == 1)
    {
        WTKOrderDetailModel *model              = array[0];
        if (self.imageArray.count <1)
        {
            UIImageView *imageView                  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
            [self.imageArray addObject:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
            imageView.layer.cornerRadius            = 5;
            imageView.layer.masksToBounds           = YES;
            imageView.layer.borderColor             = WTKCOLOR(200, 200, 200, 1).CGColor;
            imageView.layer.borderWidth             = 0.3;
            imageView.userInteractionEnabled        = YES;
            [self.w_scrollView addSubview:imageView];
        }
        else
        {
            UIImageView *imageView              = self.imageArray[0];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
            imageView.userInteractionEnabled        = YES;
            [self.w_scrollView addSubview:imageView];
        }
        if (![_w_scrollView viewWithTag:100])
        {
            UILabel* goodTitle                      = [[UILabel alloc]initWithFrame:CGRectMake(88, 0, self.w_scrollView.frame.size.width - 88, 80)];
            goodTitle.textAlignment                 = NSTextAlignmentLeft;
            goodTitle.numberOfLines                 = 0;
            goodTitle.tag                           = 100;
            goodTitle.text                          = model.title;
            goodTitle.textColor                     = WTKCOLOR(70, 70, 70, 1.0);
            goodTitle.font                          = [UIFont systemFontOfSize:14.0];
            [self.w_scrollView addSubview:goodTitle];
            self.w_scrollView.contentSize           = CGSizeMake(self.w_scrollView.frame.size.width, 80);
        }
        else
        {
            UILabel *label                          = [self.w_scrollView viewWithTag:100];
            label.text                              = model.title;
            [self.w_scrollView addSubview:label];
        }
        

        
    }
    else
    {
        if ([self.w_scrollView viewWithTag:100])
        {
            [[self.w_scrollView viewWithTag:100] removeFromSuperview];
        }
        for (int i = 0; i < array.count; i++)
        {
            UIImageView *imageView;
            if (i < self.imageArray.count)
            {
                imageView                       = self.imageArray[i];
            }
            else
            {
                imageView              = [[UIImageView alloc]initWithFrame:CGRectMake(i * 90, 0, 80, 80)];
                [self.imageArray addObject:imageView];
            }
            WTKOrderDetailModel *model          = array[i];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
            imageView.layer.cornerRadius        = 5;
            imageView.layer.masksToBounds       = YES;
            imageView.layer.borderColor         = WTKCOLOR(200, 200, 200, 1).CGColor;
            imageView.layer.borderWidth         = 0.3;
            [self.w_scrollView addSubview:imageView];
        }
        self.w_scrollView.contentSize           = CGSizeMake(90 * array.count, 80);
    }
}


- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
