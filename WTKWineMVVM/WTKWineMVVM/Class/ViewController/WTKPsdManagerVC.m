//
//  WTKPsdManagerVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPsdManagerVC.h"

@interface WTKPsdManagerVC ()
/**原密码*/
@property(nonatomic,strong)UITextField *originTextField;

/**新密码*/
@property(nonatomic,strong)UITextField *psdTextField;

/**确认密码*/
@property(nonatomic,strong)UITextField *confirmTextField;

@end

@implementation WTKPsdManagerVC

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
    NSArray *array                  = @[@"原密码",@"新密码",@"确认密码"];
    CGFloat height = 40;
    for (int i = 0 ; i < 3; i++)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 30 + 64+ (height + 5) * i, kWidth - 20, 40)];
        view.backgroundColor        = WTKCOLOR(252, 252, 252, 1);
        view.layer.cornerRadius     = 5;
        view.layer.masksToBounds    = YES;
        [self.view addSubview:view];
        UITextField *textField      = [[UITextField alloc]initWithSecure];
        textField.frame             = CGRectMake(0, 0, kWidth - 20, 40);
        textField.placeholder       = array[i];
        [view addSubview:textField];
        textField.font              = [UIFont wtkNormalFont:16];
        textField.keyboardType      = UIKeyboardTypeNumberPad;
    }
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
