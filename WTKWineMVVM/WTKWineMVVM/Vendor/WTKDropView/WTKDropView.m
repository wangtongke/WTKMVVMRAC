//
//  WTKDropView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKDropView.h"
#define IMG_TAG 10086


@interface WTKDropView ()

@property(nonatomic,strong)NSArray *array;

@property(nonatomic,assign)CGRect bgFrame;

@property(nonatomic,strong)UIScrollView *bgView;

@end

@implementation WTKDropView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray<NSString *> *)array
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    if (self)
    {
        self.array      = array;
        self.bgFrame    = frame;
        self.clickSubject = [RACSubject subject];
        self.dismissSubject = [RACSubject subject];
        [self configView];
    }
    return self;
}

- (void)configView
{
    if (self.bgFrame.size.height > 40 * self.array.count + 15)
    {
        self.bgFrame            = CGRectMake(self.bgFrame.origin.x, self.bgFrame.origin.y, self.bgFrame.size.width, 40 * self.array.count + 15);
    }
//    默认高度
    CGFloat height              = 40;
    UIImageView *imageView      = [[UIImageView alloc]initWithFrame:self.bgFrame];
    imageView.tag               = IMG_TAG;
    UIImage *image              = [UIImage imageNamed:@"orderBlack"];
    imageView.image             = [image stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    [self addSubview:imageView];
    
    self.bgView                 = [[UIScrollView alloc]initWithFrame:self.bgFrame];
    self.bgView.contentSize     = CGSizeMake(self.bgFrame.size.width, height * self.array.count + 15);
    [self addSubview:_bgView];
    
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame               = CGRectMake(self.bgFrame.size.width, idx * height + 15, self.bgFrame.size.width - 20, height - 0.3);
        btn.titleLabel.font     = [UIFont wtkNormalFont:16];
        btn.tag                 = idx + 100;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets     = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:WTKCOLOR(252, 252, 252, 1) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        
        UIView *line            = [[UIView alloc]initWithFrame:CGRectMake(self.bgFrame.size.width, idx * height + 39.7 + 15, self.bgFrame.size.width - 20, 0.3)];
        line.tag                = idx + 200;
        line.backgroundColor    = WTKCOLOR(220, 220, 220, 0.8);
        [_bgView addSubview:line];
    }];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    UIImageView *imageView      = [self viewWithTag:IMG_TAG];
    imageView.image = image;
}

- (void)btnClick:(UIButton *)btn
{
    [self.clickSubject sendNext:@{@"tag":@(btn.tag - 100),@"title":self.array[btn.tag - 100]}];
    [self dismiss];
}

- (void)beginAnimation
{
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn           = [_bgView viewWithTag:idx + 100];
        UIView   *line          = [_bgView viewWithTag:idx + 200];
        btn.frame               = CGRectMake(self.bgFrame.size.width, idx * 40 + 15, self.bgFrame.size.width, 39.7);
        line.frame              = CGRectMake(self.bgFrame.size.width, idx * 40 + 15 + 39.7, self.bgFrame.size.width - 20, 0.3);
        [UIView animateWithDuration:0.3 + 0.05 * idx
                              delay:0.1
             usingSpringWithDamping:0.9
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             btn.frame      = CGRectMake(10, idx * 40 + 15, 130, 40 - 0.3);
                             line.frame     = CGRectMake(10, idx * 40 + 39.7 + 15, self.bgFrame.size.width - 20, 0.3);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    UIImageView *imageView      = [self viewWithTag:IMG_TAG];
    imageView.frame             = CGRectMake(self.bgFrame.origin.x, self.bgFrame.origin.y, self.bgFrame.size.width, 20);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         imageView.frame = self.bgFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)dismiss
{
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn           = [self viewWithTag:idx + 100];
        UIView *line            = [self viewWithTag:idx + 200];
        [UIView animateWithDuration:0.3 - 0.02 * idx
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             btn.frame      = CGRectMake(self.bgFrame.size.width, idx * 40 + 15, 130, 40 - 0.3);
                             line.frame     = CGRectMake(self.bgFrame.size.width, idx * 40 + 39.7 + 15, 130, 0.3);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    
    UIImageView *imageView      = [self viewWithTag:IMG_TAG];
    [UIView animateWithDuration:0.2
                          delay:0.2
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         imageView.frame = CGRectMake(self.bgFrame.origin.x , self.bgFrame.origin.y, self.bgFrame.size.width, 2);
                         imageView.alpha = 0.1;
                     }
                     completion:^(BOOL finished) {
                         imageView.alpha = 1;
                         [self removeFromSuperview];
                     }];
    [self.dismissSubject sendNext:@100];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
