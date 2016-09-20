//
//  WTKHomeVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeVC.h"
#import "WTKHomeCollectionView.h"
#import "WTKSearchBar.h"
@interface WTKHomeVC ()
@property(nonatomic,strong)WTKHomeViewModel *viewModel;

@property(nonatomic,strong)WTKHomeCollectionView *collectionView;

@property(nonatomic,strong)WTKSearchBar *searchBar;

@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation WTKHomeVC
@dynamic viewModel;
- (instancetype)initWithViewModel:(WTKBasedViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self bindViewModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _setNavigationItem];
    [self configView];
}
- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    

    
    RAC(self.collectionView,headArray)  = RACObserve(self.viewModel, headData);
    RAC(self.collectionView,dataArray)  = RACObserve(self.viewModel,dataArray);
    
    self.collectionView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.collectionView];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    
//    navi
    RAC(self,leftButton.rac_command)    = RACObserve(self.viewModel, naviCommand);
   
}

- (void)configView
{
    
    [self.view addSubview:self.collectionView];
    
}
//导航
- (void)_setNavigationItem
{
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.01)] forBarMetrics:UIBarMetricsDefault];
    

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaoh"] forState:UIControlStateNormal];
    self.leftButton.frame = CGRectMake(0, 0, 25, 23);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    [RACObserve(self.collectionView, contentOffset) subscribeNext:^(id x) {
        
        CGPoint point = [x CGPointValue];
        CGFloat y = point.y;
        if (y < 0)
        {
            [self.navigationController.navigationBar setHidden:YES];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }
        else
        {
            [self.navigationController.navigationBar setHidden:NO];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
        
        if (y < kWidth * 0.23 && y >= 0)
        {
            float a = y / kWidth / 0.23;
            NSLog(@"%f",a);
            if (a < 0.9 && a > 0.02)
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, a)] forBarMetrics:UIBarMetricsDefault];
            }
        }
        if(y < kWidth * 0.23)
        {
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaob"] forState:UIControlStateNormal];
        }
        else
        {
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaoh"] forState:UIControlStateNormal];
        }
        
    }];
}

- (void)leftBtnClick
{
    
}

#pragma mark - lazyLoad
- (WTKHomeCollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[WTKHomeCollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 49) collectionViewLayout:layout];
        _collectionView.viewModel = self.viewModel;
    }
    return _collectionView;
}

- (UIButton *)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _leftButton;
}

- (WTKSearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[WTKSearchBar alloc]initWithFrame:CGRectMake(0, 0, kWidth - 120, 28)];
    }
    return _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
