//
//  WTKOrderTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTKOrderModel;

@interface WTKOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *w_statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_timeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *w_scrollView;
@property (weak, nonatomic) IBOutlet UILabel *w_priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *w_statusButton;

@property (weak, nonatomic) IBOutlet UIImageView *w_finishImage;

@property (nonatomic,strong)WTKOrderModel *order;

@end
