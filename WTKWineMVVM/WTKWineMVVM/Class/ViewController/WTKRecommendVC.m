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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation WTKRecommendVC
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forBarMetrics:UIBarMetricsDefault];
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
    
}

- (void)initView{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.layer.masksToBounds = YES;
}
- (IBAction)shareBtnClick:(UIButton *)sender
{
//    FXBlurView *blur = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    blur.blurRadius = 50;
//    blur.alpha = 0.89;
//    [[[UIApplication sharedApplication].delegate window] addSubview:blur];
    
    [WTKTool shared];
    
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
