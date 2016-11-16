//
//  WTKBasedViewController.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewController.h"

@interface WTKBasedViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong,readwrite)WTKBasedViewModel *viewModel;

@property(nonatomic,strong,readwrite)UIPercentDrivenInteractiveTransition *interactivePopTransition;


@end

@implementation WTKBasedViewController

- (instancetype)initWithViewModel:(WTKBasedViewModel *)viewModel
{
    if (self == [super init])
    {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = WTKCOLOR(240, 240, 240, 1);
    self.viewModel.naviImpl             = [[WTKViewModelNavigationImpl alloc]initWithNavigationController:self.navigationController];
    if (self.navigationController && self != self.navigationController.viewControllers.firstObject)
    {
        [self resetNaviWithTitle:@""];
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePopRecognizer:)];
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }
}

- (void)bindViewModel
{
    RAC(self.navigationItem,title)     = RACObserve(self.viewModel, title);
}


- (void)resetNaviWithTitle:(NSString *)title
{
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
//    self.navigationItem.backBarButtonItem = btn;
//    self.navigationController.navigationBar.barTintColor = THEME_COLOR;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backbutton_icon3"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    NSLog(@"progress---%.2f",progress);
    
    static BOOL flag = NO;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        flag = YES;
    }
    if (flag && progress > 0)
    {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
        flag = NO;
    }
    
//    if (progress <= 0 && !self.w_isDraging && recognizer.state != UIGestureRecognizerStateBegan) {
//        return;
//    }
//    if (recognizer.state == UIGestureRecognizerStateBegan)
//    {
//        self.w_isDraging = YES;
//        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.25)
        {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}


- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"%@--释放了",NSStringFromClass([self class]));
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
