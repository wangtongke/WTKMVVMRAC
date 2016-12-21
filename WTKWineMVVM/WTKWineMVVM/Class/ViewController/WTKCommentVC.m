//
//  WTKCommentVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentVC.h"
#import "WTKCommentViewModel.h"
#import "WTKTextView.h"
#import "WTKStarView.h"
#import "WTKOrderModel.h"
#import "WTKOrderDetailModel.h"
@interface WTKCommentVC ()

@property(nonatomic,strong)WTKCommentViewModel  *viewModel;

@property(nonatomic,strong)UIImageView          *goodImg;

@property(nonatomic,strong)WTKStarView          *starView;

@property(nonatomic,strong)WTKTextView          *textView;

@property(nonatomic,strong)UIButton             *addBtn;

@property(nonatomic,strong)UIButton             *commitBtn;

@property(nonatomic,strong)UILabel              *starLabel;

@property(nonatomic,strong)UIButton             *anonyBtn;

@property(nonatomic,strong)UIView               *bgView;


@end

@implementation WTKCommentVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    [self resetNavigation];
}
- (void)bindViewModel
{
    [super bindViewModel];
    self.viewModel.vc = self;
    @weakify(self);
    self.starView.starBlock = ^(NSString *star){
        @strongify(self);
        self.starLabel.text = [NSString stringWithFormat:@"评分：%@",star];
        [self.starLabel setText:self.starLabel.text Font:[UIFont wtkNormalFont:16] withColor:THEME_COLOR Range:NSMakeRange(3, star.length)];
    };
    RAC(self.addBtn,rac_command)    = RACObserve(self.viewModel, addPicCommand);
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.commitCommand execute:@{@"comment":self.textView.text,@"image":self.imgArray}];
    }];
    [self.viewModel.changeImgSubject subscribeNext:^(id x) {
        @strongify(self);
        [self addSelecteImg];
    }];
}

- (void)resetNavigation
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backbutton_icon3"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
- (void)backBtnClick
{
    @weakify(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [action1 setValue:THEME_COLOR forKey:@"titleTextColor"];
    [action2 setValue:WTKCOLOR(30, 30, 30, 1) forKey:@"titleTextColor"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在评价，确定离开这个页面吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

///重新布局img  flag-本次改变的第几个  isDelete是否为删除
- (void)addSelecteImg
{
    float width = kWidth / 5.0;
//  每次只处理最后一个
    if (self.imgArray.count >= 1)
    {
        @weakify(self);
        UIButton *btn = [self.imgArray lastObject];
        btn.tag = self.imgArray.count - 1;
        [btn addTarget:self action:@selector(comfirmDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset((self.imgArray.count - 1) * width);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.bgView).offset(self.imgArray.count * width);
            make.bottom.equalTo(self.bgView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
    }
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"plusbutton_icon"] forState:UIControlStateNormal];
    [self.addBtn setTitle:@"" forState:UIControlStateNormal];
    self.addBtn.backgroundColor = [UIColor clearColor];
    self.addBtn.layer.cornerRadius = width / 2.0;
}

- (void)comfirmDelete:(UIButton *)btn
{
    @weakify(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self deleteSelectImgWithIndex:btn.tag];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [action1 setValue:THEME_COLOR forKey:@"titleTextColor"];
    [action2 setValue:WTKCOLOR(30, 30, 30, 1) forKey:@"titleTextColor"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除所选图片吗" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

///删除 flag-  index
- (void)deleteSelectImgWithIndex:(NSInteger)index
{
    float width = kWidth / 5.0;
    [self.imgArray[index] removeFromSuperview];
    [self.imgArray removeObjectAtIndex:index];
    WS(weakSelf);
    for (NSInteger i = index; i < self.imgArray.count; i++)
    {
        UIButton *btn = self.imgArray[i];
        btn.tag = i;
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView).offset(i * kWidth / 5.0);
            make.bottom.equalTo(weakSelf.bgView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
    }
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(weakSelf.imgArray.count * width);
        make.bottom.equalTo(weakSelf.bgView);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
    }];
}

///匿名
- (void)anonyBtnClick:(UIButton *)btn
{
    self.anonyBtn.selected = !self.anonyBtn.selected;
}

- (void)initView
{
    //    移除右滑返回手势（与starView）
    for (UIGestureRecognizer *gesture in [self.view gestureRecognizers])
    {
        [self.view removeGestureRecognizer:gesture];
    }
    self.view.backgroundColor = WTKCOLOR(250, 250, 250, 1);
    self.imgArray = @[].mutableCopy;
    WS(weakSelf);
    UIView *bgView      = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(10 + 64);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(bgView.mas_width);
    }];
    self.goodImg        = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placehoder2"]];
    WTKOrderDetailModel *model = self.viewModel.order.ordergoods.firstObject;
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    [bgView addSubview:self.goodImg];
    [self.goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(5);
        make.left.equalTo(bgView).offset(5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
    
    self.starLabel.textColor    = WTKCOLOR(150, 150, 150, 1);
    self.starLabel.font         = [UIFont wtkNormalFont:16];
    self.starLabel.text         = @"评分：5.0";
    [self.starLabel setText:self.starLabel.text Font:[UIFont wtkNormalFont:16] withColor:THEME_COLOR Range:NSMakeRange(3, 3)];
    [bgView addSubview:self.starLabel];
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodImg);
        make.left.equalTo(weakSelf.goodImg.mas_right).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.bottom.equalTo(weakSelf.goodImg.mas_centerY);
    }];
    
    [bgView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.starLabel);
        make.top.equalTo(weakSelf.starLabel.mas_bottom);
        make.width.mas_equalTo(220);
        make.height.mas_offset(40);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = WTKCOLOR(222, 222, 222, 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodImg.mas_bottom).offset(5);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.height.mas_equalTo(0.4);
    }];
    
    self.textView.placeholder = @"说点什么吧。";
    self.textView.font = [UIFont wtkNormalFont:17];
    [bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(line).offset(5);
        make.right.equalTo(bgView).offset(-10);
        make.bottom.equalTo(bgView).offset(-65);
    }];
    
    self.addBtn.tag = 111;
    self.addBtn.layer.cornerRadius = 15;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.backgroundColor = THEME_COLOR;
    self.addBtn.titleLabel.font = [UIFont wtkNormalFont:16];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [bgView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(kWidth / 2.0);
    }];
    
    [self.anonyBtn setBackgroundImage:[UIImage imageNamed:@"w_pay_select"] forState:UIControlStateSelected];
    [self.anonyBtn setBackgroundImage:[UIImage imageNamed:@"w_pay_normal"] forState:UIControlStateNormal];
    [self.anonyBtn addTarget:self action:@selector(anonyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.anonyBtn];
    [self.anonyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(15);
        make.top.equalTo(bgView.mas_bottom).offset(15);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"匿名评价";
    tipLabel.textColor = WTKCOLOR(188, 188, 188, 1);
    tipLabel.font = [UIFont wtkNormalFont:14];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.anonyBtn);
        make.left.equalTo(weakSelf.anonyBtn.mas_right).offset(3);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(anonyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    RAC(btn,rac_command) = RACObserve(self.anonyBtn, rac_command);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tipLabel);
        make.size.equalTo(tipLabel);
    }];
    
    self.commitBtn.titleLabel.font = [UIFont wtkNormalFont:20];
    self.commitBtn.backgroundColor = THEME_COLOR;
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kWidth - 60);
    }];
}

#pragma mark - lazyLoad
- (UIButton *)commitBtn
{
    if (!_commitBtn)
    {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _commitBtn;
}
- (UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addBtn;
}

- (WTKTextView *)textView
{
    if (!_textView)
    {
        _textView = [WTKTextView textView];
    }
    return _textView;
}
- (WTKStarView *)starView
{
    if (!_starView)
    {
        _starView = [[WTKStarView alloc]initWithFrame:CGRectMake(80, 40, 220, 40) starSize:CGSizeZero withStyle:WTKStarTypeFloat];
    }
    return _starView;
}
- (UILabel *)starLabel
{
    if (!_starLabel)
    {
        _starLabel = [[UILabel alloc]init];
    }
    return _starLabel;
}
- (UIButton *)anonyBtn
{
    if (!_anonyBtn)
    {
        _anonyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _anonyBtn;
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
