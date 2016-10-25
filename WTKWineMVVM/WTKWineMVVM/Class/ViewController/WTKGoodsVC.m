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
@interface WTKGoodsVC ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong,readwrite)WTKGoodsViewModel  *viewModel;

@property(nonatomic,strong)WKWebView                    *webView;

@property(nonatomic,strong)UIButton                      *bageLabel;

@property(nonatomic,strong)UIButton                     *shoppingCarBtn;

@property(nonatomic,strong)UIButton                     *addBtn;

@property(nonatomic,strong)UIImageView                  *goodImg;




@end

@implementation WTKGoodsVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR_ALPHA] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

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
}

- (void)initView
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:THEME_COLOR_ALPHA size:CGSizeMake(kWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    [self.view addSubview:self.webView];
    NSString *urlStr = [NSString stringWithFormat:@"%@/userinfos/%@/products/%@/desc",IMG_URL,[WTKUser currentUser].bid,self.viewModel.goods.id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self.view addSubview:self.shoppingCarBtn];

    [self.view addSubview:self.addBtn];
    
    self.goodImg                            = [[UIImageView alloc]init];
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:self.viewModel.goods.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    self.goodImg.center                     = self.addBtn.center;
    self.goodImg.bounds                     = CGRectMake(0, 0, 100, 100);

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

- (UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame                       = CGRectMake(kWidth * 3 / 5, kHeight - 50, kWidth * 2 / 5, 50);
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
        _shoppingCarBtn.frame               = CGRectMake(0, kHeight - 50 , kWidth * 3 / 5, 50);
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
