//
//  WTKCommentTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentTableViewCell.h"
#import "WTKStarView.h"
#import "WTKComment.h"

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
///星级
@property(nonatomic,strong)WTKStarView      *w_starView;

@property(nonatomic,strong)UIScrollView     *w_picScrollView;

@property(nonatomic,strong)WTKComment       *comment;

///晒图
@property(nonatomic,strong)NSMutableArray   *imgArray;
@end

@implementation WTKCommentTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)updateWithComment:(WTKComment *)comment
{
    WS(weakSelf);
    self.comment                = comment;
    self.w_nameLabel.text       = comment.name;
    self.w_orderTime.text       = [NSString stringWithFormat:@"购买日期：%@",comment.order_completed_time];
    self.w_commentTime.text     = comment.created_at_str;
    self.w_comment.text         = comment.content;
    self.w_starView.star        = comment.star;
    self.w_spec.text            = [NSString stringWithFormat:@"规格：%@",comment.specification];
    [self.w_headImg sd_setImageWithURL:[NSURL URLWithString:comment.avatar_url] placeholderImage:[UIImage imageNamed:@"w_defaultHeader"]];
    if (comment.pic_thumb_path.count > 0)
    {
        [self.w_picScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(10);
            make.bottom.equalTo(weakSelf.w_spec.mas_top).offset(-10);
            make.height.mas_equalTo(70);
        }];
        [comment.pic_thumb_path enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.imgArray.count > idx)
            {
                UIImageView *imageView = self.imgArray[idx];
                imageView.frame = CGRectMake(0, idx * 70, 70, 70);
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
                [weakSelf.w_picScrollView addSubview:imageView];
            }
            else
            {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, idx * 70, 70, 70)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
                [weakSelf.w_picScrollView addSubview:imageView];
            }
        }];
        self.w_picScrollView.contentSize = CGSizeMake(70 * comment.pic_thumb_path.count, 70);
    }
    else
    {
        [self.w_picScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(10);
            make.bottom.equalTo(weakSelf.w_spec.mas_top).offset(0.01);
            make.height.mas_equalTo(0.01);
        }];
        for (UIView *view in self.w_picScrollView.subviews)
        {
            [view removeFromSuperview];
        }
    }

}

- (void)initView
{
    WS(weakSelf);
    self.backgroundColor        = WTKCOLOR(253, 253, 253, 1);
    self.w_headImg              = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_defaultHeader"]];
    _w_starView.layer.cornerRadius = 25;
    _w_starView.layer.masksToBounds = YES;
    [self addSubview:self.w_headImg];
    [self.w_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.top.equalTo(weakSelf).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    _w_nameLabel                = [[UILabel alloc]init];
    _w_nameLabel.textColor      = WTKCOLOR(120, 120, 120, 1);
    _w_nameLabel.font           = [UIFont wtkNormalFont:16];
    [self addSubview:_w_nameLabel];
    [_w_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.w_headImg);
        make.left.equalTo(weakSelf.w_headImg.mas_right).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    _w_commentTime              = [[UILabel alloc]init];
    _w_commentTime.textColor    = WTKCOLOR(100, 100, 100, 1);
    _w_commentTime.font         = [UIFont wtkNormalFont:14];
    _w_commentTime.textAlignment= NSTextAlignmentRight;
    [self addSubview:_w_commentTime];
    [_w_commentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-10);
        make.centerY.equalTo(weakSelf.w_headImg);
        make.left.equalTo(weakSelf.w_nameLabel.mas_right);
        make.height.mas_equalTo(25);
    }];
    
    _w_starView                 = [[WTKStarView alloc]initWithFrame:CGRectMake(10, 70, 100, 20) starSize:CGSizeZero withStyle:WTKStarTypeInteger];
    [self addSubview:_w_starView];
    [_w_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.top.equalTo(weakSelf.w_headImg.mas_bottom).offset(12);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    UIView *bottomView          = [[UIView alloc]init];
    bottomView.backgroundColor  = WTKCOLOR(230, 230, 230, 1);
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(20);
    }];
    
    _w_orderTime                = [[UILabel alloc]init];
    _w_orderTime.textColor      = self.w_nameLabel.textColor;
    _w_orderTime.font           = [UIFont wtkNormalFont:14];
    [self addSubview:_w_orderTime];
    [_w_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.bottom.equalTo(bottomView.mas_top).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    _w_spec                     = [[UILabel alloc]init];
    _w_spec.textColor           = self.w_nameLabel.textColor;
    _w_spec.font                = [UIFont wtkNormalFont:14];
    [self addSubview:_w_spec];
    [_w_spec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.bottom.equalTo(weakSelf.w_orderTime.mas_top).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    _w_picScrollView            = [[UIScrollView alloc]init];
    [self addSubview:_w_picScrollView];
    [_w_picScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(10);
        make.bottom.equalTo(_w_spec.mas_top).offset(-10);
        make.height.mas_equalTo(70);
    }];
    
    _w_comment                  = [[UILabel alloc]init];
    _w_comment.textColor        = WTKCOLOR(70, 70, 70, 1);
    _w_comment.font             = [UIFont wtkNormalFont:16];
    _w_comment.numberOfLines    = 0;
    [self addSubview:_w_comment];
    [_w_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.w_starView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-15);
        make.bottom.equalTo(weakSelf.w_picScrollView.mas_top).offset(-10);
    }];
}

- (NSMutableArray *)imgArray
{
    if (!_imgArray)
    {
        _imgArray = @[].mutableCopy;
    }
    return _imgArray;
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
