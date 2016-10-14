//
//  WTKWebVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKWebVC.h"
#import "WTKWebViewModel.h"
#import <WebKit/WebKit.h>
@interface WTKWebVC ()
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)WTKWebViewModel *viewModel;
@end

@implementation WTKWebVC
@dynamic viewModel;
#pragma mark - lifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    [self createSubView];
}

- (void)createSubView
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
    
    _webView                    = [[WKWebView alloc]initWithFrame:self.view.frame];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.urlString]]];
    [self.view addSubview:_webView];
    
    _progressView                   = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    _progressView.progressTintColor = [UIColor greenColor];
    [self.view addSubview:_progressView];
    _progressView.progress          = 0;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress >= 1.0)
        {
            self.progressView.hidden = YES;
        }
    }
}
- (void)dealloc
{
    NSLog(@"释放了");
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
