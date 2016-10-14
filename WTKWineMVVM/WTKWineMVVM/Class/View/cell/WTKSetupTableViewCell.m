//
//  WTKSetupTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSetupTableViewCell.h"

@implementation WTKSetupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateTitle:(NSString *)title subTitle:(NSString *)subtitle
{
    self.w_titleLabel.text  = title;
    self.w_subTitle.text    = subtitle;
    if (subtitle.length > 0)
    {
        self.w_imageView.hidden = YES;
    }
    else
    {
        self.w_imageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
