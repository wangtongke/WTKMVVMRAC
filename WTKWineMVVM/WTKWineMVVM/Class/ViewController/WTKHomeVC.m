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
@interface WTKHomeVC ()<UISearchBarDelegate>
@property(nonatomic,strong)WTKHomeViewModel *viewModel;

@property(nonatomic,strong)WTKHomeCollectionView *collectionView;

@property(nonatomic,strong)WTKSearchBar *searchBar;

@property(nonatomic,strong)UIButton *leftButton;

@property(nonatomic,strong)UIButton *rightBtn;

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

    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.01)] forBarMetrics:UIBarMetricsDefault];
    

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaoh"] forState:UIControlStateNormal];
    self.leftButton.frame = CGRectMake(0, 0, 25, 23);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxib"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, 25, 23);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    [RACObserve(self.collectionView, contentOffset) subscribeNext:^(id x) {
        
        CGPoint point = [x CGPointValue];
        CGFloat y = point.y;
        if (y < 0)
        {

//            [self.navigationController.navigationBar setHidden:YES];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
        else
        {
//            [self.navigationController.navigationBar setHidden:NO];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }
        
        if (y < kWidth * 0.23 && y >= 0)
        {
            float a = y / kWidth / 0.23;
            NSLog(@"%f",a);
            if (a < 0.9 && a > 0.02)
            {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, a)] forBarMetrics:UIBarMetricsDefault];
            }
            if (a < 0.5)
            {
                self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            }
            else
            {
                self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            }
        }
        if(y < kWidth * 0.23)
        {
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaob"] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxib"] forState:UIControlStateNormal];
            self.searchBar.wtk_bgColor = WTKCOLOR(240, 240, 240, 0.5);
        }
        else
        {
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"wtksaoyisaoh"] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxih"] forState:UIControlStateNormal];
            self.searchBar.wtk_bgColor = WTKCOLOR(160, 160, 160, 0.5);
        }
        
    }];
        self.navigationItem.titleView = self.searchBar;
    self.searchBar.center = CGPointMake(kWidth / 2.0, self.searchBar.center.y);
    
}

#pragma mark - searchDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.viewModel.searchSubject sendNext:@1];
    return NO;
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
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightBtn;
}

- (WTKSearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[WTKSearchBar alloc]initWithFrame:CGRectMake(0, 60, kWidth - 120, 28)];
        _searchBar.layer.cornerRadius = 5;
        _searchBar.layer.masksToBounds = YES;
        CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
        CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
        CGRect frame;
        CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
        maxWidth += 15;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
        frame = _searchBar.frame;
        
        frame.size.width = kWidth - maxWidth * 2;
        
        _searchBar.frame = frame;
        _searchBar.searchBar.delegate = self;
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
