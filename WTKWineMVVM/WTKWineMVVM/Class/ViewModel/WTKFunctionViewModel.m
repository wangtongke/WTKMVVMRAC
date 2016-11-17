//
//  WTKFunctionViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKFunctionViewModel.h"

@implementation WTKFunctionViewModel

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
    self.switchCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UISwitch *sw = input;
        if (sw.tag == 0)
        {
            CURRENT_USER.isSound = sw.on;
        }
        else if (sw.tag == 1)
        {
            CURRENT_USER.isShake = sw.on;
        }
        else
        {
            if (sw.on)
            {
                [WTKTool registTouchIDWithCompleteBlock:^(NSString *str) {
                    if ([str isEqualToString:@"验证成功"])
                    {
                        sw.on = YES;
                        SHOW_SUCCESS(@"验证成功");
                    }
                    else
                    {
                        sw.on = NO;
                        SHOW_ERROE(str);
                        DISMISS_SVP(1.3);
                    }
                }];
            }
            else
            {
                [WTKTool delegateTouchID];
            }
        }
        return [RACSignal empty];
    }];
}

@end
