//
//  WTKSearchResultView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSearchResultView.h"
#import "WTKHomeCell.h"
#import "WTKSearchViewModel.h"
@interface WTKSearchResultView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource>

@property(nonatomic,strong)UICollectionView *collectionView;
///购物车
@property(nonatomic,strong)UIButton         *shoppingcarBtn;

@property(nonatomic,strong)UILabel          *bageLabel;

@property(nonatomic,assign)NSInteger        bageValue;

@end

@implementation WTKSearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    @weakify(self);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView             = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.dataSource  = self;
    self.collectionView.delegate    = self;
    self.collectionView.emptyDataSetSource = self;
    _collectionView.backgroundColor = WTKCOLOR(240, 240, 240, 1);
    [self.collectionView registerClass:[WTKHomeCell class] forCellWithReuseIdentifier:@"search"];
    [self addSubview:self.collectionView];
    
    self.shoppingcarBtn.frame       = CGRectMake(kWidth - 80 * ZOOM_SCALL, kHeight - 80 * ZOOM_SCALL - 64, 60 * ZOOM_SCALL, 60 * ZOOM_SCALL);
    [self.shoppingcarBtn setBackgroundImage:[UIImage imageNamed:@"w_shoppingcar"] forState:UIControlStateNormal];
    [self addSubview:self.shoppingcarBtn];
    [[self.shoppingcarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"TO3");
        [self.viewModel.shoppingCarCommand execute:@1];
    }];
    
    self.bageLabel.backgroundColor  = [UIColor redColor];
    _bageLabel.textColor            = [UIColor whiteColor];
    _bageLabel.textAlignment        = NSTextAlignmentCenter;
    _bageLabel.layer.cornerRadius   = 10;
    _bageLabel.layer.masksToBounds  = YES;
    _bageLabel.font                 = [UIFont wtkNormalFont:12];
    [self addSubview:_bageLabel];
    
    RAC(self,bageValue)             = RACObserve(CURRENT_USER, bageValue);
    
}
///bageValue动画
- (void)beginAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _bageLabel.font    = [UIFont wtkNormalFont:14];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             _bageLabel.font                 = [UIFont wtkNormalFont:12];
                         }];
    }];
}
- (void)setBageValue:(NSInteger)bageValue
{
    _bageValue                      = bageValue;
    self.bageLabel.text             = [NSString stringWithFormat:@"%ld",bageValue];
    [self beginAnimation];
}
- (void)w_reloadData
{
    [self.collectionView reloadData];
}
#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.goodCommand execute:self.dataArray[indexPath.row]];
}

#pragma mark - collectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTKHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"search" forIndexPath:indexPath];
    cell.isSearch = YES;
    WTKGood *good = self.dataArray[indexPath.row];
    [cell updateGood:good];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWidth - 30) / 2.0, (kWidth - 30) / 2.0 + 64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark - DNZEmptyDataSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"暂时没搜到商品，您可以更换关键词试试"];
    [string addAttribute:NSForegroundColorAttributeName value:WTKCOLOR(70, 70, 70, 1) range:NSMakeRange(0, 10)];
    
    return string;
}


#pragma mark - lazyLoad
- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[];
    }
    return _dataArray;
}
- (UIButton *)shoppingcarBtn
{
    if (!_shoppingcarBtn)
    {
        _shoppingcarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _shoppingcarBtn;
}
- (UILabel *)bageLabel
{
    if (!_bageLabel)
    {
        _bageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 65 * ZOOM_SCALL - 12 * ZOOM_SCALL, kHeight - 64 - 65 * ZOOM_SCALL - 15 * ZOOM_SCALL, 20 * ZOOM_SCALL, 20 * ZOOM_SCALL)];
    }
    return _bageLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
