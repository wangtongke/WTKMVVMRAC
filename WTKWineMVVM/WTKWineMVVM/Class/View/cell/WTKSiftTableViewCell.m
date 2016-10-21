//
//  WTKSiftTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSiftTableViewCell.h"
#import "WTKSiftModel.h"
@implementation WTKSiftTableViewCell


- (void)updateWithModel:(WTKSiftModel *)model
{
    self.w_Label.text = model.name;
    if (model.isSelected)
    {
        self.w_imageView.hidden = NO;
        self.w_Label.textColor  = THEME_COLOR;
    }
    else
    {
        self.w_Label.textColor  = WTKCOLOR(80, 80, 80, 1);
        self.w_imageView.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
