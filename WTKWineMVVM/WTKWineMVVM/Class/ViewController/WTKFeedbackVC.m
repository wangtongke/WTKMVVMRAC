//
//  WTKFeedbackVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/13.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKFeedbackVC.h"

@interface WTKFeedbackVC ()

@property(nonatomic,strong)UITextView   *textView;

@property(nonatomic,strong)UIButton     *menuBtn;

@end

@implementation WTKFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
}

- (void)initView
{
    @weakify(self);
    UIView *topBG           = [[UIView alloc]init];
    topBG.backgroundColor   = [UIColor whiteColor];
    [self.view addSubview:topBG];
    [topBG mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    UILabel *label          = [[UILabel alloc]init];
    label.textColor         = WTKCOLOR(70, 70, 70, 1);
    label.text              = @"意见反馈";
    label.font              = [UIFont wtkNormalFont:16];
    [topBG addSubview:label];
    [topBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBG).offset(18);
        make.centerY.equalTo(topBG);
        make.height.mas_equalTo(30);
        make.width.equalTo(@100);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_xia"]];
    [topBG addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBG).offset(-20);
        make.centerY.equalTo(topBG);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    self.menuBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuBtn.titleLabel.font = [UIFont wtkNormalFont:14];
    [_menuBtn setTitle:@"功能意见" forState:UIControlStateNormal];
    [_menuBtn setTitleColor: WTKCOLOR(100, 100, 100, 1) forState:UIControlStateNormal];
    [topBG addSubview:_menuBtn];
    [_menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left).offset(3);
        
    }];
    
    [self.view addSubview:self.textView];
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc]init];
    }
    return _textView;
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
