//
//  WTKHomeCollectionView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeCollectionView.h"
#import "WTKHomeCell.h"
#import "WTKHomeHeadView.h"

@interface WTKHomeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,assign)BOOL isAnimation;

@end

@implementation WTKHomeCollectionView



- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.backgroundColor        = WTKCOLOR(240, 240, 240, 1);
    self.delegate               = self;
    self.dataSource             = self;
    [self registerClass:[WTKHomeCell class] forCellWithReuseIdentifier:@"cell"];
    [self registerClass:[WTKHomeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.emptyDataSetSource     = self;
    self.emptyDataSetDelegate   = self;
}



#pragma mark - dataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTKHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateGood:self.dataArray[indexPath.row]];
    
    return cell;
}
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    WTKHomeHeadView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    head.dataArray = self.headArray.mutableCopy;
    @weakify(self);
    [head.bannerSubject subscribeNext:^(id x) {
        @strongify(self);
        NSInteger num = [x integerValue];
        [self.viewModel.headCommand execute:self.headArray[num]];
    }];
    [head.btnSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.btnCommand execute:x];
    }];
    return head;
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.goodCommand execute:self.dataArray[indexPath.row]];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isAnimation)
    {
        return;
    }
    CGAffineTransform tran = CGAffineTransformMakeTranslation(cell.transform.tx, cell.transform.ty + 70);
    cell.transform = tran;
    [UIView animateWithDuration:0.8 animations:^{
        cell.transform = CGAffineTransformMakeTranslation(cell.transform.tx, cell.transform.ty - 70);
    }];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat y = 0;
    if (scrollView.contentOffset.y > y)
    {
        self.isAnimation = YES;
    }
    else
    {
        self.isAnimation = NO;
    }
    y = scrollView.contentOffset.y;
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.headArray.count <= 0)
    {
        return CGSizeZero;
    }
    return CGSizeMake(kWidth, kWidth * 0.6);
}

#pragma mark - DZNEmptyData

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    [[WTKNetWork shareInatance] initNetWork];
    if ([WTKNetWork shareInatance].isNetReachable)
    {
        return [UIImage imageNamed:@"NotWorkViews"];
    }
    return [UIImage imageNamed:@"w_dian4"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    [[WTKNetWork shareInatance] initNetWork];
    if ([WTKNetWork shareInatance].isNetReachable)
    {
        return [[NSAttributedString alloc]initWithString:@"网络不好"];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"当前地址暂未开通服务"];
    [string addAttribute:NSForegroundColorAttributeName value:WTKCOLOR(70, 70, 70, 1) range:NSMakeRange(0, 10)];
    
    return string;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
    [self.mj_header beginRefreshing];
}

#pragma mark - lazyLoad
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSArray *)headArray
{
    if (!_headArray)
    {
        _headArray = [NSArray array];
    }
    return _headArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
