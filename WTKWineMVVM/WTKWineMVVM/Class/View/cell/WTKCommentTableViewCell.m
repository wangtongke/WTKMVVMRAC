//
//  WTKCommentTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentTableViewCell.h"

@interface WTKCommentTableViewCell ()

///头像
@property(nonatomic,strong)UIImageView      *w_headImg;
///名字
@property(nonatomic,strong)UILabel          *w_nameLabel;
///评论日期
@property(nonatomic,strong)UILabel          *w_commentTime;

///购买日期
@property(nonatomic,strong)UILabel          *w_orderTime;

///评论
@property(nonatomic,strong)UILabel          *w_comment;

///购买日期
@property(nonatomic,strong)UILabel          *w_spec;

@end

@implementation WTKCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
