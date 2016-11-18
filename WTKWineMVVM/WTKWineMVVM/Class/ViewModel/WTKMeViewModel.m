//
//  WTKMeViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMeViewModel.h"
#import "WTKOrderViewModel.h"
#import "WTKRecommendViewModel.h"
#import "WTKLoginViewModel.h"
#import "WTKWebViewModel.h"
#import "WTKSetupViewModel.h"
#import "WTKFeedBackViewModel.h"
#import "WTKAboutMeViewModel.h"
#import "WTKCommentCenterViewModel.h"


@implementation WTKMeViewModel

- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:service params:params];
    if (self)
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    
    self.setUpSubject       = [RACSubject subject];
    [self.setUpSubject subscribeNext:^(id x) {
        NSLog(@"shezhi");
        WTKSetupViewModel *viewModel    = [[WTKSetupViewModel alloc]initWithService:self.services params:@{@"title":@"设置"}];
        self.naviImpl.className         = @"WTKSetUpVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
    }];
    
    self.cellClickSubject   = [RACSubject subject];
    [self.cellClickSubject subscribeNext:^(id x) {
        NSLog(@"cell点击%@",x);
        NSInteger num = [x integerValue];
        switch (num) {
            case 0:
            {
//                全部订单
                WTKOrderViewModel *viewModel = [[WTKOrderViewModel alloc]initWithService:self.services params:@{@"title":@"全部订单"}];
                viewModel.orderType = 0;
                self.naviImpl.className = @"WTKOrderVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
            case 1:
            {
//                钱包查看明细
                [SVProgressHUD showImage:[UIImage imageNamed:@"w_error"] status:@"敬请期待"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
                break;
            case 2:
            {
//                推荐有奖
                WTKRecommendViewModel *viewModel    = [[WTKRecommendViewModel alloc]initWithService:self.services params:@{@"title":@"推荐有奖"}];
                self.naviImpl.className             = @"WTKRecommendVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
            case 3:
            {
//                意见反馈
                WTKFeedBackViewModel *viewModel     = [[WTKFeedBackViewModel alloc]initWithService:self.services params:@{@"title":@"意见反馈"}];
                self.naviImpl.className             = @"WTKFeedbackVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
            case 4:
            {
//                客服热线
                
            }
                break;
            case 5:
            {
//                酒运达
                WTKWebViewModel *viewModel  = [[WTKWebViewModel alloc]initWithService:self.services params:@{@"title":@"酒运达"}];
                viewModel.urlString         = @"http://a.eqxiu.com/s/dH91BoVd";
                self.naviImpl.className     = @"WTKWebVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
    
    self.headClickSubject = [RACSubject subject];
    [self.headClickSubject subscribeNext:^(id x) {
        NSLog(@"head点击%@",x);
        NSInteger num = [x integerValue];
        switch (num) {
            case 4:
            {
//                积分
                SHOW_ERROE(@"敬请期待");
                DISMISS_SVP(1.2);
            }
                break;
            case 5:
            {
//                酒库
                SHOW_ERROE(@"敬请期待");
                DISMISS_SVP(1.2);
            }
                break;
            case 6:
            {
//                优惠券
                SHOW_ERROE(@"敬请期待");
                DISMISS_SVP(1.2);
            }
                break;
            case 7:
            {
//                酒券
                SHOW_ERROE(@"敬请期待");
                DISMISS_SVP(1.2);
            }
                break;
            case 8:
            {
//                点击头像
                if ([self judgeWhetherLogin:YES])
                {
                    NSLog(@"YES");
                    WTKAboutMeViewModel *viewModel = [[WTKAboutMeViewModel alloc]initWithService:self.services params:@{@"title":@"我的信息"}];
                    self.naviImpl.className = @"WTKAboutMeVC";
                    [self.naviImpl pushViewModel:viewModel animated:YES];
                }
                else
                {
                    NSLog(@"no");
                }
            }
                break;
            case 9:
            {
//                收藏
            }
                break;
            case 10:
            {
//                足迹
            }
                break;
                
            default:
            {
//                订单
                NSArray *arr = @[@"待支付",@"配送中",@"待配送",@"待评价"];
                if (num == 3)
                {
                    WTKCommentCenterViewModel *viewModel = [[WTKCommentCenterViewModel alloc]initWithService:self.services params:@{@"title":@"评价中心"}];
                    self.naviImpl.className = @"WTKCommentCenterVC";
                    [self.naviImpl pushViewModel:viewModel animated:YES];
                }
                else
                {
                    WTKOrderViewModel *viewModel = [[WTKOrderViewModel alloc]initWithService:self.services params:@{@"title":arr[num]}];
                    viewModel.orderType = num + 1;
                    self.naviImpl.className = @"WTKOrderVC";
                    [self.naviImpl pushViewModel:viewModel animated:YES];
                }
                
            }
                break;
        }
    }];
}

@end
