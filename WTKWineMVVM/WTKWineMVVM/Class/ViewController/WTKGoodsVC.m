//
//  WTKGoodsVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGoodsVC.h"
#import "WTKGoodsViewModel.h"
#import <WebKit/WebKit.h>
#import "WTKTouchManager.h"
#import "WTKCommentTableView.h"
#import "WTKCommentBtn.h"

@interface WTKGoodsVC ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property(nonatomic,strong,readwrite)WTKGoodsViewModel  *viewModel;

@property(nonatomic,strong)WKWebView                    *webView;

@property(nonatomic,strong)UIButton                     *bageLabel;
///shoppingCar
@property(nonatomic,strong)UIButton                     *shoppingCarBtn;
///add
@property(nonatomic,strong)UIButton                     *addBtn;

@property(nonatomic,strong)UIImageView                  *goodImg;

@property(nonatomic,strong)UIButton                     *shareBtn;

///bg
@property(nonatomic,strong)UIScrollView                 *scrollView;

@property(nonatomic,strong)UISegmentedControl           *titleView;
///评论
@property(nonatomic,strong)WTKCommentTableView          *tableView;
///评论head
@property(nonatomic,strong)UIView                       *headView;

@property(nonatomic,strong)NSMutableArray               *headBtnArray;

///上次选择
@property(nonatomic,assign)NSInteger                    lastSelect;

///评论标题
@property(nonatomic,strong)NSDictionary                 *titleDic;




@end

@implementation WTKGoodsVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR_ALPHA] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(80, 80, 80, 1)};

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    [self resetNavi];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.goodImg.center = self.addBtn.center;
        [self.viewModel.addCommand execute:self.goodImg];
//       角标动画
        [self bageValueAnimation];
    }];
    
    RAC(self.shoppingCarBtn,rac_command)    = RACObserve(self.viewModel, clickShopCommand);
    RAC(self.bageLabel,rac_command)         = RACObserve(self.viewModel, clickShopCommand);
    RAC(self.shareBtn,rac_command)          = RACObserve(self.viewModel, shareCommand);
    RAC(self.tableView,dataArray)           = RACObserve(self.viewModel, commentArray);
    RAC(self,titleDic)                      = RACObserve(self.viewModel, titleDic);
    [[self.titleView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
         NSInteger page = self.titleView.selectedSegmentIndex;
        [self.scrollView setContentOffset:CGPointMake(kWidth * page, -64) animated:YES];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.tableView];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initView
{
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:THEME_COLOR_ALPHA size:CGSizeMake(kWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.webView];
    NSString *urlStr = [NSString stringWithFormat:@"%@/userinfos/%@/products/%@/desc",IMG_URL,[WTKUser currentUser].bid,self.viewModel.goods.id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self.scrollView addSubview:self.shoppingCarBtn];

    [self.scrollView addSubview:self.addBtn];
    
    self.goodImg                            = [[UIImageView alloc]init];
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:self.viewModel.goods.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    self.goodImg.center                     = self.addBtn.center;
    self.goodImg.bounds                     = CGRectMake(0, 0, 100, 100);
    
    
#pragma mark - 右侧
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.tableView];

}
///导航栏
- (void)resetNavi
{
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
    self.navigationItem.titleView           = self.titleView;
}
///刷新评论标题
- (void)setTitleDic:(NSDictionary *)titleDic
{
    _titleDic = titleDic;
    NSArray *titleNum = @[titleDic[@"whole"],titleDic[@"good"],titleDic[@"middle"],titleDic[@"bad"],titleDic[@"picture"]];
    NSArray *title = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
    [self.headBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WTKCommentBtn *btn = obj;
        [btn setTitle:title[idx] subTitle:titleNum[idx]];
    }];
    
}

#pragma mark - headBtnClick
- (void)headBtnClick:(UIButton *)btn
{
    if (btn.tag == self.lastSelect)
    {
        return;
    }
    [self.viewModel.menuCommand execute:@(btn.tag)];
    WTKCommentBtn *lastBtn = self.headBtnArray[self.lastSelect];
    lastBtn.w_titleColor = WTKCOLOR(80, 80, 80, 1);
    WTKCommentBtn *newBtn = (WTKCommentBtn *)btn;
    newBtn.w_titleColor = THEME_COLOR;
    self.lastSelect = btn.tag;
}

/**角标动画*/
- (void)bageValueAnimation
{
    if ([WTKUser currentUser].bageValue >= 0)
    {
        self.bageLabel.hidden               = NO;
    }
    [self.bageLabel setTitle:[NSString stringWithFormat:@"%ld",[WTKUser currentUser].bageValue] forState:UIControlStateNormal];
    @weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        @strongify(self);
        self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 30, 30);

        self.bageLabel.titleLabel.font      = [UIFont wtkNormalFont:17];

    } completion:^(BOOL finished) {
        @strongify(self);
        [UIView animateWithDuration:0.2 animations:^{
            self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 25, 25);
            self.bageLabel.titleLabel.font      = [UIFont wtkNormalFont:14];
            
        }];
    }];
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.titleView.selectedSegmentIndex = page;
}

#pragma mark - lazyLoad
- (UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame                       = CGRectMake(kWidth * 3 / 5, kHeight - 50 - 64, kWidth * 2 / 5, 50);
        _addBtn.backgroundColor             = THEME_COLOR;
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIButton *)shoppingCarBtn
{
    if (!_shoppingCarBtn)
    {
        _shoppingCarBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCarBtn.frame               = CGRectMake(0, kHeight - 50 - 64, kWidth * 3 / 5, 50);
        _shoppingCarBtn.backgroundColor     = WTKCOLOR(30, 30, 30, 0.8);
        
        UIImageView *imgView                = [[UIImageView alloc]initWithFrame:CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 - 25, 0, 50, 50)];
        imgView.image                       = [UIImage imageNamed:@"gouwuche"];
        [self.shoppingCarBtn addSubview:imgView];
        self.bageLabel                      = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 25, 25);
        self.bageLabel.titleLabel.font      = [UIFont wtkNormalFont:14];
        [self.bageLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bageLabel setTitle:[NSString stringWithFormat:@"%ld",[WTKUser currentUser].bageValue] forState:UIControlStateNormal];
        [self.bageLabel setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        self.bageLabel.titleLabel.textAlignment        = NSTextAlignmentCenter;
        if ([WTKUser currentUser].bageValue == 0)
        {
            self.bageLabel.hidden           = YES;
        }
        
        [_shoppingCarBtn addSubview:self.bageLabel];
    }
    return _shoppingCarBtn;
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50 )];
        _webView.navigationDelegate     = self;
        _webView.UIDelegate             = self;
    }
    return _webView;
}
- (UIButton *)shareBtn
{
    if (!_shareBtn)
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"w_share"] forState:UIControlStateNormal];
        _shareBtn.frame = CGRectMake(0, 0, 20, 20);
    }
    return _shareBtn;
}
- (UISegmentedControl *)titleView
{
    if (!_titleView)
    {
        _titleView        = [[UISegmentedControl alloc]initWithItems:@[@"详情",@"评价"]];
        _titleView.frame  = CGRectMake(0, 0, 100, 30);
        NSDictionary *selectDic = @{NSForegroundColorAttributeName :WTKCOLOR(70, 70, 70, 1),NSFontAttributeName:[UIFont wtkNormalFont:14]};
        NSDictionary *normalDic = @{NSForegroundColorAttributeName :WTKCOLOR(140, 140, 140, 1),NSFontAttributeName:[UIFont wtkNormalFont:14]};
        [_titleView setTitleTextAttributes:selectDic forState:UIControlStateSelected];
        [_titleView setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        _titleView.selectedSegmentIndex = 0;
        _titleView.tintColor  = THEME_COLOR;
    }
    return _titleView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.contentSize = CGSizeMake(kWidth * 2, _scrollView.frame.size.height - 64);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIView *)headView
{
    if (!_headView)
    {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, 50)];
        NSArray *title = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
        CGFloat width = kWidth  / 5.0;
        for (int i = 0; i < 5; i++)
        {
            WTKCommentBtn *btn  = [WTKCommentBtn buttonWithTitle:title[i] subTitle:@"0"];
            btn.frame           = CGRectMake(width * i, 0, width, 50);
            btn.tag             = i;
            btn.w_titleColor    = i == 0 ? THEME_COLOR : WTKCOLOR(80, 80, 80, 1);
            [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:btn];
            [self.headBtnArray addObject:btn];
        }
    }
    return _headView;
}
- (WTKCommentTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[WTKCommentTableView alloc] initWithFrame:CGRectMake(kWidth, 50, kWidth, kHeight - 50 - 64) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSMutableArray *)headBtnArray
{
    if (!_headBtnArray)
    {
        _headBtnArray = @[].mutableCopy;
    }
    return _headBtnArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
