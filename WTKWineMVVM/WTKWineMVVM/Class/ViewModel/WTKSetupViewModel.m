//
//  WTKSetupViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSetupViewModel.h"
#import "WTKFunctionViewModel.h"
#import "WTKAboutMeView.h"
#import "WTKPsdManagerViewModel.h"

@implementation WTKSetupViewModel

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
    self.cellClickSubject   = [RACSubject subject];
    [self.cellClickSubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
        NSInteger tag = [x[0] integerValue];
        switch (tag)
        {
            case 0:
            {
                if ([[WTKTool getCacheSize] floatValue] == 0)
                {
                    SHOW_ERROE(@"暂无要清除的内容");
                    DISMISS_SVP(1.2);
                }
                else
                {
                    [[SDWebImageManager sharedManager] cancelAll];
                    [[SDWebImageManager sharedManager].imageCache clearMemory];
                    [[SDWebImageManager sharedManager].imageCache clearDisk];
                    SHOW_SUCCESS(@"清除完成");
                    DISMISS_SVP(1.3);
                    UITableView *table = x[1];
                    [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
                break;
            case 1:
            {
//                功能
                WTKFunctionViewModel *viewModel = [[WTKFunctionViewModel alloc]initWithService:self.services params:@{@"title":@"功能"}];
                self.naviImpl.className         = @"WTKFunctionVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
            case 2:
            {
//                关于
                WTKAboutMeView *aboutView       = [[WTKAboutMeView alloc]initWithFrame:CGRectMake(kWidth / 6.0 , kHeight / 3.0, kWidth / 3.0 * 2.0, kWidth / 3.0 * 2.0 + 30) withTitleArray:@[@"确定"]];
                [[[UIApplication sharedApplication].delegate window] addSubview:aboutView];
            }
                break;
            case 3:
            {
//                帮助中心
                
            }
                break;
            case 4:
            {
//                密码管理
                WTKPsdManagerViewModel *viewModel = [[WTKPsdManagerViewModel alloc]initWithService:self.services params:@{@"title":@"密码修改"}];
                self.naviImpl.className         = @"WTKPsdManagerVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
                
            default:
                break;
        }
        
        
    }];
    
    self.exitSubject        = [RACSubject subject];
    [self.exitSubject subscribeNext:^(id x) {
        UITableView *tableView = x;
        [WTKTool exit];
        [tableView reloadData];
    }];
}

@end
