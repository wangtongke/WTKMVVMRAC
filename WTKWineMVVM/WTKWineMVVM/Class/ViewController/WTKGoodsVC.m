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
@interface WTKGoodsVC ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong,readwrite)WTKGoodsViewModel *viewModel;
@property(nonatomic,strong)WKWebView *webView;




@end

@implementation WTKGoodsVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
}

- (void)initView{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:THEME_COLOR size:CGSizeMake(kWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    NSString *urlStr = [NSString stringWithFormat:@"%@/userinfos/%@/products/%@/desc",@"http://www.jiuyunda.net:90",[WTKUser currentUser].bid,self.viewModel.goods.id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc]initWithFrame:self.view.frame];
        _webView.navigationDelegate     = self;
        _webView.UIDelegate             = self;
        [self.view addSubview:_webView];
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
