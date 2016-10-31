//
//  WTKSearchViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSearchViewModel.h"



@implementation WTKSearchViewModel

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
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        RACSignal *signal = [WTKRequestManager postArrayDataWithURL:@"SearchResult" withpramater:nil];
        return signal;
    }];
}

@end
