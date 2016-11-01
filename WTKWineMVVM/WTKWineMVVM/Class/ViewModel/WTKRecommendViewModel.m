//
//  WTKRecommendViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/8.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKRecommendViewModel.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>

@implementation WTKRecommendViewModel

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
    self.refershCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [[WTKRequestManager postWithURL:@"http://www.jiuyunda.net:90/api/v1/shareIntegral/share_info" withParamater:@{@"userinfo_id":[WTKUser currentUser].bid,@"customer_id":@"57f8ac945b73294b2d7a97ad"}] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        
        return [RACSignal empty];
    }];
    
    self.shareCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self share];
        
        return [RACSignal empty];
    }];
}
- (void)share{
    [[WTKTool shared] subscribeNext:^(id x) {
        
        NSInteger tag = [x integerValue];
        NSInteger type;
         NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        switch (tag) {
            case 100:
            {
                type = SSDKPlatformSubTypeWechatSession;
               
                [shareParams SSDKSetupWeChatParamsByText:@"免费送了"
                                                   title:@"贱卖"
                                                     url:[NSURL URLWithString:@"http://www.jianshu.com/users/f3e780fd1a4e/latest_articles"]
                                              thumbImage:@"http://img.51xiaoniu.cn/product/main_assets/assets/573e/6d28/206a/af4e/87f2/b739/573dc0e1af48433144e07ae5.jpg@!thumb"
                                                   image:@"http://img.51xiaoniu.cn/product/main_assets/assets/573e/6d28/206a/af4e/87f2/b739/573dc0e1af48433144e07ae5.jpg@!avatar"
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAuto
                                      forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            }
                break;
            case 102:
            {
                type = SSDKPlatformSubTypeQQFriend;
                [shareParams SSDKSetupQQParamsByText:@"免费送了" title:@"贱卖" url:[NSURL URLWithString:@"http://www.jianshu.com/users/f3e780fd1a4e/latest_articles"] thumbImage:@"http://img.51xiaoniu.cn/product/main_assets/assets/573e/6d28/206a/af4e/87f2/b739/573dc0e1af48433144e07ae5.jpg@!thumb" image:@"http://img.51xiaoniu.cn/product/main_assets/assets/573e/6d28/206a/af4e/87f2/b739/573dc0e1af48433144e07ae5.jpg@!avatar" type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                

            }
                break;
                
            default:
                break;
        }
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state)
            {
                case SSDKResponseStateSuccess:
                {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
                    break;
                case SSDKResponseStateFail:
                {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        
    }];
}
@end
