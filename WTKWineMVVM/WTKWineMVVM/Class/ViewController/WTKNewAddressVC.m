//
//  WTKNewAddressVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKNewAddressVC.h"
#import "WTKNewAddressViewModel.h"
#import "WTKSexView.h"
@interface WTKNewAddressVC ()<UITextFieldDelegate>

@property(nonatomic,strong)WTKNewAddressViewModel   *viewModel;

@property(nonatomic,strong)UITextField              *nameTXF;

@property(nonatomic,strong)UITextField              *phoneTXF;

@property(nonatomic,strong)UITextField              *addressTXF;

@property(nonatomic,strong)UIScrollView             *scrollView;
/// 通讯录
@property(nonatomic,strong)UIButton                 *phoneBook;

@property(nonatomic,strong)WTKSexView               *sexView;

@property(nonatomic,strong)UIButton                 *saveBtn;

@end

@implementation WTKNewAddressVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}
- (void)bindViewModel
{
    [super bindViewModel];
    self.viewModel.vc = self;
    RAC(self.phoneBook,rac_command)     = RACObserve(self.viewModel, phoneBookCommand);
//    RAC(self.saveBtn,rac_command)       = RACObserve(self.viewModel, saveCommand);
//    需传值
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.saveCommand execute:@{@"name":self.nameTXF.text,
                                              @"sex":@(self.sexView.w_sex),
                                              @"phone":self.phoneTXF.text,
                                              @"adress":self.addressTXF.text}];
    }];
    
    
//    从通讯录选取联系人
    RAC(self.phoneTXF,text)             = RACObserve(self.viewModel, phoneNum);
}

#pragma mark - textViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.addressTXF)
    {
        [self.viewModel.addressCommand execute:textField];
        return NO;
    }
    return YES;
}

- (void)initView
{
    @weakify(self);
    self.scrollView                     = [[UIScrollView alloc]init];
    self.scrollView.contentSize         = CGSizeMake(kWidth, kHeight - 64);
    _scrollView.alwaysBounceVertical    = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    UIView *bgView                      = [[UIView alloc]init];
    bgView.backgroundColor              = [UIColor whiteColor];
    [self.scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.scrollView).offset(15);
        make.left.equalTo(self.scrollView);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(160);
    }];
    
    UILabel *topLabel                   = [[UILabel alloc]init];
    topLabel.textColor                  = WTKCOLOR(120, 120, 120, 1);
    topLabel.text                       = @"联 系 人";
    topLabel.font                       = [UIFont wtkNormalFont:14];
    [bgView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(10);
        make.height.mas_equalTo(39.7);
        make.width.mas_equalTo(80);
    }];
    
    self.nameTXF.font                   = [UIFont wtkNormalFont:14];
    self.nameTXF.placeholder            = @"请输入姓名";
    [bgView addSubview:self.nameTXF];
    [self.nameTXF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(80);
        make.top.equalTo(bgView);
        make.right.equalTo(bgView).offset(-80);
        make.height.mas_equalTo(39.7);
    }];
    
    [self.phoneBook setBackgroundImage:[UIImage imageNamed:@"phonebook"] forState:UIControlStateNormal];
    [bgView addSubview:self.phoneBook];
    [self.phoneBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-20);
        make.top.equalTo(bgView).offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [bgView addSubview:self.sexView];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.nameTXF);
        make.top.equalTo(self.nameTXF.mas_bottom);
        make.right.equalTo(self.phoneBook.mas_left);
        make.height.mas_equalTo(40);
    }];
    
    
    UIView *line1                       = [[UIView alloc]init];
    line1.backgroundColor               = WTKCOLOR(215, 215, 215, 1);
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView);
        make.top.equalTo(self.sexView.mas_bottom);
        make.height.mas_equalTo(0.4);
    }];
    
    UILabel *midLabel                   = [[UILabel alloc]init];
    midLabel.text                       = @"手机号码";
    midLabel.textColor                  = WTKCOLOR(120, 120, 120, 1);
    midLabel.font                       = [UIFont wtkNormalFont:14];
    [bgView addSubview:midLabel];
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.sexView.mas_bottom);
        make.left.equalTo(bgView).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(39.6);
    }];
    
    self.phoneTXF.font                  = [UIFont wtkNormalFont:14];
    self.phoneTXF.placeholder           = @"请输入手机号";
    [bgView addSubview:self.phoneTXF];
    [self.phoneTXF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midLabel);
        make.left.equalTo(midLabel.mas_right);
        make.right.equalTo(bgView);
        make.height.mas_equalTo(39.6);
    }];
    
    UILabel *bottomLabel                = [[UILabel alloc]init];
    bottomLabel.text                    = @"地址";
    bottomLabel.textColor               = WTKCOLOR(120, 120, 120, 1);
    bottomLabel.font                    = [UIFont wtkNormalFont:14];
    [bgView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView);
        make.left.equalTo(bgView).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(39.6);
    }];
    
    self.addressTXF.font                  = [UIFont wtkNormalFont:14];
    self.addressTXF.placeholder           = @"请选择地址";
    [bgView addSubview:self.addressTXF];
    [self.addressTXF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomLabel);
        make.left.equalTo(bottomLabel.mas_right);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bottomLabel);
    }];
    UIView *line2                       = [[UIView alloc]init];
    line2.backgroundColor               = WTKCOLOR(215, 215, 215, 1);
    [bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-39.8);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.scrollView addSubview:self.saveBtn];
    _saveBtn.backgroundColor            = [UIColor whiteColor];
    _saveBtn.layer.cornerRadius         = 5;
    _saveBtn.layer.masksToBounds        = YES;
    _saveBtn.layer.borderColor          = THEME_COLOR.CGColor;
    _saveBtn.layer.borderWidth          = 0.4;
    _saveBtn.titleLabel.font            = [UIFont wtkNormalFont:20];
    [_saveBtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(30);
        make.centerX.equalTo(bgView);
        make.width.mas_equalTo(kWidth - 60);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - lazyLoad
- (UITextField *)nameTXF
{
    if (!_nameTXF)
    {
        _nameTXF = [[UITextField alloc]init];
    }
    return _nameTXF;
}
- (UITextField *)phoneTXF
{
    if (!_phoneTXF)
    {
        _phoneTXF = [[UITextField alloc]init];
        _phoneTXF.delegate = self;
    }
    return _phoneTXF;
}
- (UITextField *)addressTXF
{
    if (!_addressTXF)
    {
        _addressTXF = [[UITextField alloc]init];
        _addressTXF.delegate = self;
    }
    return _addressTXF;
}
- (UIButton *)phoneBook
{
    if (!_phoneBook)
    {
        _phoneBook = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _phoneBook;
}
- (WTKSexView *)sexView
{
    if (!_sexView)
    {
        _sexView = [[WTKSexView alloc]init];
    }
    return _sexView;
}
- (UIButton *)saveBtn
{
    if (!_saveBtn)
    {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _saveBtn;
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
