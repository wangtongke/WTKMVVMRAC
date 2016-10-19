//
//  WTKLoginVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKLoginVC.h"
#import "WTKLoginViewModel.h"


@interface WTKLoginVC ()<UITextFieldDelegate>

@property(nonatomic,strong)WTKLoginViewModel    *viewModel;

@property(nonatomic,weak)IBOutlet UITextField          *phoneTextField;

@property(nonatomic,weak)IBOutlet UITextField          *psdTextField;

@property(nonatomic,weak)IBOutlet UIButton             *codeBtn;

@property(nonatomic,weak)IBOutlet UIButton             *loginBtn;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;

@end

@implementation WTKLoginVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.99)] forBarMetrics:UIBarMetricsDefault];
}


- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    RAC(self.viewModel,phoneNum)            = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel,codeNum)             = self.psdTextField.rac_textSignal;
    
    RAC(self.loginBtn,enabled)              = self.viewModel.canLoginSignal;
    RAC(self.codeBtn,enabled)               = self.viewModel.canCodeSignal;
    
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.codeCommand execute:x];
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.loginCommand execute:x];
    }];
    
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x[@"code"] integerValue] == 100)
        {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

    
}


- (void)initView
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
    
    self.phoneTextField.delegate            = self;
    self.phoneTextField.keyboardType        = UIKeyboardTypeNumberPad;
    self.psdTextField.delegate              = self;
    self.psdTextField.keyboardType          = UIKeyboardTypeNumberPad;
    
    self.codeBtn.layer.cornerRadius         = 6;
    self.codeBtn.layer.masksToBounds        = YES;
    self.codeBtn.layer.borderColor          = THEME_COLOR.CGColor;
    self.codeBtn.layer.borderWidth          = 0.3;
    self.codeBtn.enabled                    = NO;
    
    self.loginBtn.layer.cornerRadius        = 6;
    self.loginBtn.layer.masksToBounds       = YES;
    self.loginBtn.layer.borderColor         = THEME_COLOR.CGColor;
    self.loginBtn.layer.borderWidth         = 0.3;
    self.loginBtn.enabled                   = NO;
    [self.loginBtn setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(210, 210, 210, 1)] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:THEME_COLOR forState:UIControlStateDisabled];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.codeBtn setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(210, 210, 210, 1)] forState:UIControlStateDisabled];
    [self.codeBtn setBackgroundImage:[UIImage imageFromColor:THEME_COLOR] forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:THEME_COLOR forState:UIControlStateDisabled];
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.voiceLabel.textColor               = WTKCOLOR(70, 70, 70, 1);
    [self.voiceLabel setText:@"收不到验证码？使用语音验证" Font:[UIFont wtkNormalFont:14] withColor:[UIColor blueColor] Range:NSMakeRange(9, 4)];
    
    
}
- (IBAction)yuyinBtnClick:(id)sender {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不支持" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0)
    {
        return YES;
    }
    if (textField == self.phoneTextField)
    {
        if (textField.text.length >= 13)
        {
            return NO;
        }
        if (textField.text.length == 3 || textField.text.length == 8)
        {
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        return YES;
    }
    else
    {
        if (textField.text.length >= 4)
        {
            return NO;
        }
    }
    
    return YES;
}
- (void)dealloc
{
    NSLog(@"dealloc");
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
