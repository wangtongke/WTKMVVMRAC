//
//  WTKOrderStateTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKOrderStateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel        *w_timeLabel;

@property (weak, nonatomic) IBOutlet UIView         *w_topLine;

@property (weak, nonatomic) IBOutlet UIView         *w_bottomLine;

@property (weak, nonatomic) IBOutlet UIImageView    *w_tatusImageView;
@property (weak, nonatomic) IBOutlet UILabel        *w_statusLabel;

@end
