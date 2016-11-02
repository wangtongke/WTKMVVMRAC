//
//  WTKFoundVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKFoundVC.h"

@interface WTKFoundVC ()

@end

@implementation WTKFoundVC
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"userinfo_id"] = CURRENT_USER.bid;
    dic[@"product_id"] = @"5757ec4baf48430bef628827";
    dic[@"page"] = @1;
    dic[@"level"] = @2;
    [[WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/productComment/comment_list" withParamater:dic] subscribeNext:^(id x) {
        NSLog(@"评论----%@",x);
    }];
    
//    [[WTKRequestManager postArrayDataWithURL:Home_Data withpramater:nil] subscribeNext:^(id x) {
//        NSArray *array = x;
//        for (NSDictionary *dic in array)
//        {
//            WTKGood *good = [[WTKGood alloc]initWithDic:dic];
//            NSMutableDictionary *dic = @{}.mutableCopy;
//            dic[@"userinfo_id"] = CURRENT_USER.bid;
//            dic[@"product_id"] = good.id;
//            dic[@"page"] = @1;
//            dic[@"level"] = @0;
//            [[WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/productComment/comment_list" withParamater:dic] subscribeNext:^(id x) {
//                NSDictionary *dic1 = x[@"data"];
//                NSArray *numArray = dic1[@"comment_list"];
//                NSLog(@"id-%@-tu-%@---num = %@",good.id,good.title,dic1[@"comment_count"][@"whole"]);
//            }];
//            
//        }
//    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
