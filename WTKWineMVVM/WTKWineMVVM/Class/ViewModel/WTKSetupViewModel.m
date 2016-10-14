//
//  WTKSetupViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSetupViewModel.h"

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
        [[SDWebImageManager sharedManager] cancelAll];
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        SHOW_SUCCESS(@"清除完成");
        DISMISS_SVP(1.3);
        UITableView *table = x[1];
        [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    self.exitSubject        = [RACSubject subject];
    [self.exitSubject subscribeNext:^(id x) {
        UITableView *tableView = x;
        [WTKTool exit];
        [tableView reloadData];
    }];
}

@end
