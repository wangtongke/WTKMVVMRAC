//
//  WTKMapViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMapViewModel.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
@interface WTKMapViewModel ()

@end

@implementation WTKMapViewModel

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
    @weakify(self);
    self.addressSubject = [RACSubject subject];
    self.cellClick      = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        BMKPoiInfo *poiInfo = input;
        NSDictionary *dic = @{@"address":poiInfo.address,@"city":poiInfo.city,@"name":poiInfo.name};
        @strongify(self);
        [self.addressSubject sendNext:dic];
        [self.naviImpl popViewControllerWithAnimation:YES];
        return [RACSignal empty];
    }];
}





@end
