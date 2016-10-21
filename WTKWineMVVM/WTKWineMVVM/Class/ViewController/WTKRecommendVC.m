//
//  WTKRecommendVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/8.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKRecommendVC.h"
#import "WTKRecommendViewModel.h"
#import "FXBlurView.h"
@interface WTKRecommendVC ()

@property(nonatomic,strong)WTKRecommendViewModel *viewModel;

@property(nonatomic,strong)NSDictionary *dataDic;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation WTKRecommendVC
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR_ALPHA] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    
}
- (void)bindViewModel
{
    [super bindViewModel];
    [self.viewModel.refershCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
    }];
    RAC(self.shareBtn,rac_command)  = RACObserve(self.viewModel, shareCommand);
    
}

- (void)initView{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(253, 253, 253, 1)};
    [self.view addSubview:self.imageView];
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kWidth * 25.0 / 32.0);
    }];
    
    UILabel *topLabel       = [[UILabel alloc]init];
    topLabel.font           = [UIFont wtkNormalFont:19];
    topLabel.textColor      = WTKCOLOR(70, 70, 70, 1);
    topLabel.textAlignment  = NSTextAlignmentCenter;
    [topLabel setText:@"送给朋友8000积分大礼包，您也可" Font:[UIFont wtkNormalFont:19] withColor:THEME_COLOR Range:NSMakeRange(4, 4)];
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
        make.height.equalTo(@37);
    }];
    
    UILabel *botmLabel       = [[UILabel alloc]init];
    botmLabel.font           = [UIFont wtkNormalFont:19];
    botmLabel.textColor      = WTKCOLOR(70, 70, 70, 1);
    botmLabel.textAlignment  = NSTextAlignmentCenter;
    [botmLabel setText:@"以获得2000的积分" Font:[UIFont wtkNormalFont:19] withColor:THEME_COLOR Range:NSMakeRange(3, 4)];
    [self.view addSubview:botmLabel];
    [botmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(5);
        make.left.equalTo(topLabel);
        make.right.equalTo(topLabel);
        make.height.equalTo(@37);
    }];
    
    [self.view addSubview:self.shareBtn];
    
    self.shareBtn.titleLabel.font   = [UIFont wtkNormalFont:20];
    self.shareBtn.backgroundColor   = THEME_COLOR;
    [self.shareBtn setTitle:@"分享到社交媒体" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.layer.masksToBounds = YES;
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(botmLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@45);
    }];
}
- (void)shareBtnClick:(UIButton *)sender
{
//    FXBlurView *blur = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    blur.blurRadius = 50;
//    blur.alpha = 0.89;
//    [[[UIApplication sharedApplication].delegate window] addSubview:blur];
    
    [WTKTool shared];
    
}

- (UIButton *)shareBtn
{
    if (!_shareBtn)
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _shareBtn;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"wtkRecommend"];
    }
    return _imageView;
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
