//
//  WTKPsdManagerVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPsdManagerVC.h"
#import "WTKPsdManagerViewModel.h"


@interface WTKPsdManagerVC ()<UITextFieldDelegate>

@property(nonatomic,strong)WTKPsdManagerViewModel   *viewModel;
/**原密码*/
@property(nonatomic,strong)UITextField              *w_originTextField;

/**新密码*/
@property(nonatomic,strong)UITextField              *w_newTextField;

/**确认密码*/
@property(nonatomic,strong)UITextField              *w_confirmTextField;

@property(nonatomic,strong)UIButton                 *confirmBtn;

@end

@implementation WTKPsdManagerVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    RAC(self.viewModel,w_originPsd)         = self.w_originTextField.rac_textSignal;
    RAC(self.viewModel,w_newPsd)            = self.w_newTextField.rac_textSignal;
    RAC(self.viewModel,w_confirmPsd)        = self.w_confirmTextField.rac_textSignal;

    RAC(self.confirmBtn,enabled)            = self.viewModel.canSignal;
    
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.confirmCommand execute:x];
    }];

}

- (void)initView
{
    self.confirmBtn.frame                   = CGRectMake(20, 290, kWidth - 40, 50);
    self.confirmBtn.enabled                 = NO;
    self.confirmBtn.layer.cornerRadius      = 5;
    self.confirmBtn.layer.masksToBounds     = YES;
    self.confirmBtn.layer.borderColor       = THEME_COLOR.CGColor;
    self.confirmBtn.layer.borderWidth       = 0.3;
    self.confirmBtn.titleLabel.font         = [UIFont wtkNormalFont:18];
    [self.confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(210, 210, 210, 1)] forState:UIControlStateDisabled];
    [self.view addSubview:self.confirmBtn];
    
//  由于不是懒加载创建，所以绑定写在创建view之后
}


#pragma mark - TextFielDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0)
    {
        return YES;
    }
    if (textField.text.length >= 6)
    {
        return NO;
    }
    return YES;
}


#pragma mark - 懒加载
- (UITextField *)w_originTextField
{
    if (!_w_originTextField)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 30 + 64+ (40 + 10) * 0, kWidth - 20, 40)];
        view.backgroundColor        = WTKCOLOR(252, 252, 252, 1);
        view.layer.cornerRadius     = 5;
        view.layer.masksToBounds    = YES;
        [self.view addSubview:view];
        _w_originTextField       = [[UITextField alloc]initWithSecure];
        _w_originTextField.frame            = CGRectMake(0, 0, kWidth - 20, 40);
        _w_originTextField.placeholder      = @"原密码";
        _w_originTextField.font             = [UIFont wtkNormalFont:16];
        _w_originTextField.keyboardType     = UIKeyboardTypeNumberPad;
        _w_originTextField.delegate         = self;
        _w_originTextField.frame            = CGRectMake(0, 0, kWidth - 20, 40);
        [view addSubview:_w_originTextField];
    }
    return _w_originTextField;
}
- (UITextField *)w_newTextField
{
    if (!_w_newTextField)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 30 + 64+ (40 + 10) * 1, kWidth - 20, 40)];
        view.backgroundColor        = WTKCOLOR(252, 252, 252, 1);
        view.layer.cornerRadius     = 5;
        view.layer.masksToBounds    = YES;
        [self.view addSubview:view];
        _w_newTextField = [[UITextField alloc]initWithSecure];
        _w_newTextField.frame               = CGRectMake(0, 0, kWidth - 20, 40);
        _w_newTextField.placeholder         = @"新密码（6位）";
        _w_newTextField.font                = [UIFont wtkNormalFont:16];
        _w_newTextField.keyboardType        = UIKeyboardTypeNumberPad;
        _w_newTextField.delegate            = self;
        _w_newTextField.frame               = CGRectMake(0, 0, kWidth - 20, 40);
        [view addSubview:_w_newTextField];
    }
    return _w_newTextField;
}
- (UITextField *)w_confirmTextField
{
    if (!_w_confirmTextField)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 30 + 64+ (40 + 10) * 2, kWidth - 20, 40)];
        view.backgroundColor        = WTKCOLOR(252, 252, 252, 1);
        view.layer.cornerRadius     = 5;
        view.layer.masksToBounds    = YES;
        [self.view addSubview:view];
        _w_confirmTextField = [[UITextField alloc]initWithSecure];
        _w_confirmTextField.frame           = CGRectMake(0, 0, kWidth - 20, 40);
        _w_confirmTextField.placeholder     = @"确认密码（6位）";
        _w_confirmTextField.font            = [UIFont wtkNormalFont:16];
        _w_confirmTextField.keyboardType    = UIKeyboardTypeNumberPad;
        _w_confirmTextField.delegate        = self;
        _w_confirmTextField.frame           = CGRectMake(0, 0, kWidth - 20, 40);
        [view addSubview:_w_confirmTextField];
    }
    return _w_confirmTextField;
}
- (UIButton *)confirmBtn
{
    if (!_confirmBtn)
    {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _confirmBtn;
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
