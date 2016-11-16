//
//  WTKStarView.m
//  WTKStarCommentDemo
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKStarView.h"

#define WHITE_NAME @"w_star_white"
#define RED_NAME @"w_star_red"

@interface WTKStarView ()

@property(nonatomic,assign)WTKStarType      starType;

@property(nonatomic,assign)CGSize           starSize;

@property(nonatomic,strong)NSMutableArray   *starArray;

@property(nonatomic,assign)CGFloat          width;
@property(nonatomic,assign)CGFloat          height;
@property(nonatomic,assign)CGFloat          lineMargin;
@property(nonatomic,assign)CGFloat          listMargin;

@property(nonatomic,strong)UIView           *foreView;
@property(nonatomic,strong)UIView           *bgView;

@end

@implementation WTKStarView

- (instancetype)initWithFrame:(CGRect)frame starSize:(CGSize)starSize withStyle:(WTKStarType)style
{
    if (self = [super initWithFrame:frame])
    {
        self.starType = style;
        self.starSize = starSize;
        self.isTouch = YES;
        [self initView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initView
{
    self.starArray      = [NSMutableArray array];
    CGFloat width;
    CGFloat height;
    CGFloat lineMargin;
    CGFloat listMargin;
    if(self.starSize.width == 0 || self.starSize.width > self.frame.size.width / 5.0)
    {
        width = self.frame.size.width / 8.0;
        if (width > self.frame.size.height)
        {
            width = self.frame.size.height;
        }
        height = width;
        lineMargin = MAX(0, (self.frame.size.height - height) / 2.0);
        listMargin = (self.frame.size.width - 5.0 * width) / 5.0;
    }
    else
    {
        width = self.starSize.width;
        if (width > self.frame.size.height)
        {
            width = self.frame.size.height;
        }

        height = self.starSize.height > self.frame.size.height ? width : self.starSize.height;
        lineMargin = MAX((self.frame.size.height - height) / 2.0, 0);
        listMargin = (self.frame.size.width - width * 5.0) / 5.0;
    }
    self.width      = width;
    self.height     = height;
    self.lineMargin = lineMargin;
    self.listMargin = listMargin;
    if (self.starType == WTKStarTypeInteger)
    {
        for (int i = 0; i < 5; i++)
        {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:RED_NAME]];
            imgView.frame = CGRectMake(i * (width + listMargin) + listMargin / 2.0, lineMargin, width, height);
            [self addSubview:imgView];
            [self.starArray addObject:imgView];
        }
    }
    else
    {
        [self initForFloatStar];
    }

    
}
///允许半颗星
- (void)initForFloatStar
{
    self.foreView   = [self createViewWithImageName:RED_NAME withFlag:YES];
    self.bgView     = [self createViewWithImageName:WHITE_NAME withFlag:NO];
    [self addSubview:self.bgView];
    [self addSubview:self.foreView];
}
- (UIView *)createViewWithImageName:(NSString *)name withFlag:(BOOL)flag
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 5; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        imgView.frame = CGRectMake(i * (self.width + self.listMargin) + self.listMargin / 2.0, self.lineMargin, self.width, self.height);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
        if (flag)
        {
            [self.starArray addObject:imgView];
        }
    }
    return view;
}

#pragma mark - SET
- (void)setStar:(CGFloat)star
{
    star = MAX(0, MIN(5.0, star));
    _star = self.starType == 0 ? (int)star : star;
    if (self.starType == 0)
    {
        _star = _star == 0 ? 1 : _star;
        [self.starArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *img = obj;
            if (idx + 1 <= star)
            {
                img.image = [UIImage imageNamed:RED_NAME];
            }
            else
            {
                img.image = [UIImage imageNamed:WHITE_NAME];
            }
        }];
    }
    else
    {
        int value = star;
        CGFloat width = (value) * (self.width + self.listMargin) + self.listMargin / 2.0 + (star - value) * self.width;
        self.foreView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }
}


#pragma mark - touch
///点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch)
    {
        return;
    }
    if(self.starType == WTKStarTypeInteger)
    {
        [self resetIntegerStar:touches];
    }
    else
    {
        [self resetFloatStar:touches];
    }
    
}
///移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch)
    {
        return;
    }
    if(self.starType == WTKStarTypeInteger)
    {
        [self resetIntegerStar:touches];
    }
    else
    {
        [self resetFloatStar:touches];
    }
}

- (void)resetFloatStar:(NSSet<UITouch *> *)touches
{

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint starPoint;
    int flag = 0;//判断是否已经调用block
    CGFloat star = 0;
    
    if (touchPoint.x >= 0 && touchPoint.x < self.frame.size.width && touchPoint.y >= 0 && touchPoint.y < self.frame.size.height)
    {
        for (int i = 0; i < 5; i++)
        {
            UIImageView *img = self.starArray[i];
                starPoint = [touch locationInView:img];
                if (starPoint.x >= 0 && starPoint.x <= self.width)
                {///在星星上
                    CGFloat value = starPoint.x / self.width;
                    self.foreView.frame = CGRectMake(0, 0, img.frame.origin.x + value * self.width, self.frame.size.height);
                    if(flag == 0 && self.starBlock)
                    {
                        self.starBlock([NSString stringWithFormat:@"%.1f",i + value]);
                    }
                    flag++;
                }
                else
                {
                    self.foreView.frame = CGRectMake(0, 0, touchPoint.x, self.frame.size.height);
                    if (touchPoint.x > img.frame.origin.x)
                    {
                        star = i + 1;
                    }
                }
        }
        if (flag == 0 && self.starBlock)
        {
            //       没有调用block，当前点击不在星星上
            self.starBlock([NSString stringWithFormat:@"%.1f",star]);
        }
    }
    
    
}

- (void)resetIntegerStar:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger star = 0;
    for (int i = 0; i < 5; i++)
    {
        UIImageView *img = self.starArray[i];
        if (touchPoint.x >= 0 && touchPoint.x < self.frame.size.width && touchPoint.y >= 0 && touchPoint.y < self.frame.size.height)
        {
            if (img.frame.origin.x > touchPoint.x)
            {
                img.image = [UIImage imageNamed:WHITE_NAME];
            }
            else
            {
                img.image = [UIImage imageNamed:RED_NAME];
                star++;
            }
        }
    }
    if (self.starBlock)
    {
        self.starBlock([NSString stringWithFormat:@"%ld",star]);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
