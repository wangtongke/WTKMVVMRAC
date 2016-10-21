//
//  WTKGoodManagerView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGoodManagerView.h"
#import "WTKGood.h"


@interface WTKGoodManagerView ()
@property (nonatomic, strong) UIButton *wtkLeftButton;
@property (nonatomic, strong) UIButton *wtkRightButton;
@property (nonatomic, strong) UILabel *wtkNumLable;
@property (nonatomic, assign) NSInteger stokeNum;
@property (nonatomic, strong) WTKGood *goods;


@property (nonatomic, assign) BOOL isHiddenButton;
@end

@implementation WTKGoodManagerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.addSubject = [RACSubject subject];
        [self configView];
    }
    return self;
}

- (void)configView
{
    CGFloat subviesH = 40;
    CGFloat subviewW = 30;
    self.backgroundColor            = [UIColor clearColor];
    _wtkLeftButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _wtkLeftButton.backgroundColor  = [UIColor clearColor];
    _wtkLeftButton.layer.masksToBounds=YES;
    _wtkLeftButton.layer.cornerRadius=subviesH/2;
    _wtkLeftButton.frame = (CGRect){0, 0, subviesH, subviesH};
    [_wtkLeftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_wtkLeftButton];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage newImageWithNamed:@"minusbutton_icon" size:(CGSize){30,30}]];
    imageView1.frame = CGRectMake(10, 5, 30, 30);
    [_wtkLeftButton addSubview:imageView1];
    
    
    //2.添加一个中间的显示选择数量的label
    _wtkNumLable                    = [[UILabel alloc]init];
    _wtkNumLable.frame              = (CGRect){ subviesH, 5 , subviewW, subviewW};
    _wtkNumLable.textAlignment      = NSTextAlignmentCenter;
    _wtkNumLable.textColor          = [UIColor colorWithRed:40 / 255.0 green:40 / 255.0 blue:40 / 255.0 alpha:1];
    _wtkNumLable.font               = [UIFont wtkNormalFont:16];
    _wtkNumLable.text               = @"";
    [self addSubview:_wtkNumLable];
    
    //3.添加一个右边的加号按钮
    _wtkRightButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _wtkRightButton.backgroundColor = [UIColor clearColor];
    _wtkRightButton.layer.masksToBounds=YES;
    _wtkRightButton.layer.cornerRadius=subviesH/2;
    _wtkRightButton.tag = 500;
    _wtkRightButton.frame = (CGRect){ subviesH+subviewW, 0, subviesH, subviesH};
    [_wtkRightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_wtkRightButton];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage newImageWithNamed:@"plusbutton_icon" size:(CGSize){30,30}]];
    imageView2.frame = CGRectMake(0, 5, 30, 30);
    [_wtkRightButton addSubview:imageView2];
    

    
    _wtkLeftButton.hidden = YES;
    _wtkNumLable.hidden = YES;
}
///点击减
- (void)leftBtnClick:(UIButton *)btn
{
     SHOPPING_MANAGER.flag = NO;
    self.num = self.num - 1;
    self.goods.num = self.num;
    if (self.goods.num == 0)
    {
        [[WTKShoppingManager manager].goodsDic removeObjectForKey:self.goods.id];
        [self.reduceSubject sendNext:self.goods.id];
    }
    else
    {
        [[WTKShoppingManager manager].goodsDic setObject:self.goods forKey:self.goods.id];
    }
    [WTKUser currentUser].bageValue--;
}

///点击加
- (void)rightBtnClick:(UIButton *)btn
{
    SHOPPING_MANAGER.flag = NO;
    self.goods.w_isSelected = YES;
    if (self.num >= self.stokeNum)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"wtkError"] status:@"库存不足"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    self.num = self.num + 1;
    self.goods.num = self.num;
    [self.addSubject sendNext:[NSNumber numberWithInteger:self.num]];
    [[WTKShoppingManager manager].goodsDic setObject:self.goods forKey:self.goods.id];
//    角标
    [WTKUser currentUser].bageValue++;
    
}

- (void)updateGood:(WTKGood *)good
{
    self.stokeNum   = good.stock;
    self.num        = good.num;
    
    self.goods      = good;

}

- (void)setNum:(NSInteger)num
{
    _num = num;
    if (num <= 0)
    {
        self.wtkLeftButton.hidden   = YES;
        self.wtkNumLable.hidden     = YES;
    }
    else
    {
        self.wtkLeftButton.hidden   = NO;
        self.wtkNumLable.hidden     = NO;
        self.wtkNumLable.text       = [NSString stringWithFormat:@"%ld",num];
    }
}

- (void)awakeFromNib
{
    self.addSubject = [RACSubject subject];
    self.reduceSubject = [RACSubject subject];
    [self configView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
