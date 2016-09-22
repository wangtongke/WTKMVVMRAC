//
//  WTKHomeHeadView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeHeadView.h"
#import "WTKHomeBannerCollectionViewCell.h"
@interface WTKHomeHeadView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView     *collectionView;

@property(nonatomic,assign)BOOL                 isDragging;

@property(nonatomic,strong)NSTimer              *timer;

@property(nonatomic,strong)UILabel              *getMoney;
@property(nonatomic,strong)UILabel              *allMoney;

@property(nonatomic,strong)NSMutableArray       *imageArray;
@end

@implementation WTKHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bannerSubject  = [RACSubject subject];
        self.btnSubject     = [RACSubject subject];
        self.isDragging     = NO;
        [self configView];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    self.imageArray                     = dataArray.mutableCopy;
    id lastObj                          = [dataArray lastObject];
    id firstObj                         = [dataArray firstObject];
    [self.imageArray insertObject:lastObj atIndex:0];
    [self.imageArray addObject:firstObj];
    
    [self.collectionView reloadData];
    
    self.collectionView.contentOffset = CGPointMake(kWidth, 0);
    
    if (self.timer)
    {
        return;
    }
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMethod) userInfo:@"" repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.timer.fireDate = [NSDate distantPast];
}

- (void)configView
{
    self.imageArray                     = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize                     = CGSizeMake(kWidth, kWidth * 122 / 320.0);
    layout.minimumLineSpacing           = 0;
    layout.minimumInteritemSpacing      = 0;
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView                 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 122 / 320.0) collectionViewLayout:layout];
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    _collectionView.pagingEnabled       = YES;
    _collectionView.bounces             = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WTKHomeBannerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    @weakify(self);
//    创建4个btn
    NSArray *nameArray = @[@"home_food",@"home_fruit",@"home_living_goods",@"home_help_buy"];
    NSArray *lableArray = @[@"酒库",@"推荐有奖",@"酒卷",@"订单"];
    float buttonW = 50;// btn的边长
    for (int i=0; i<4; i++) {
        float columnInterval = (kWidth - 200)/5.0;
        
        float x = columnInterval+(buttonW+columnInterval)*i;
        float y = self.collectionView.frame.size.height + 10;
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.frame = CGRectMake( x, y , 45, 45);
        [button setBackgroundImage:[UIImage imageNamed:nameArray[i]] forState:UIControlStateNormal];
        
        [self addSubview:button];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(button.frame.origin.x - 2.5, y + 45 + 3, button.frame.size.width + 5, 20);
        label.font = [UIFont wtkNormalFont:12];
        label.text = lableArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            UIButton *btn = x;
            [self.btnSubject sendNext:[NSNumber numberWithInteger:btn.tag]];
        }];
    }
    
}



- (void)resetCollectionViewContentOffset
{
    if(self.imageArray.count <= 1)
    {
        return;
    }
    self.collectionView.contentOffset = CGPointMake(kWidth, 0);
}


- (void)timerMethod
{
    if (self.isDragging)
    {
        return;
    }
    CGPoint offSet = self.collectionView.contentOffset;
    int x = offSet.x;
    int width = kWidth;
    if (x % width !=0)
    {
        offSet.x = kWidth;
    }
    offSet.x += kWidth;
    [_collectionView setContentOffset:offSet animated:YES];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragging     = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isDragging = NO;
    });
}

#pragma mark - collectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTKHomeBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    NSURL *url = [NSURL URLWithString:self.imageArray[indexPath.row][@"img"]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.jiuyunda.net:90%@",self.imageArray[indexPath.row][@"img"]]];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headPlaceholder.jpg"]];
    return cell;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    滚动结束
    int row = collectionView.contentOffset.x / kWidth;
    if (row == 0)
    {
        collectionView.contentOffset = CGPointMake(kWidth * (self.imageArray.count - 2), 0);
    }
    
    if(row == self.imageArray.count - 1)
    {
        collectionView.contentOffset = CGPointMake(kWidth, 0);
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.bannerSubject sendNext:[NSNumber numberWithInteger:indexPath.row - 1]];
}

@end
