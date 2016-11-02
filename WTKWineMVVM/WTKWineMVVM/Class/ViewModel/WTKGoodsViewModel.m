//
//  WTKGoodsViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGoodsViewModel.h"
#import "WTKGood.h"
#import "WTKShoppingCarViewModel.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import "WTKComment.h"

@interface WTKGoodsViewModel ()

///当前选择的类型
@property(nonatomic,assign)NSInteger selectType;

@property(nonatomic,strong)NSArray *typeArray;

@property(nonatomic,strong)NSMutableDictionary *dataDic;

@end

@implementation WTKGoodsViewModel

- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    
    self = [super initWithService:service params:params];
    if (self)
    {
        self.selectType = 0;
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    @weakify(self);
    self.addCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSLog(@"%@",input);
        [WTKTool beginAddAnimationWithImageView:input animationTime:0.6 startPoint:CGPointMake(kWidth * 4 / 5, kHeight - 25) endPoint:CGPointMake(kWidth * 1.5 / 5, kHeight - 25)];
        [WTKUser currentUser].bageValue ++;
        
        self.goods.num++;
        [[WTKShoppingManager manager].goodsDic setObject:self.goods forKey:self.goods.id];
        
        return [RACSignal empty];
    }];
    
    self.clickShopCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        self.naviImpl.selectedIndex = 3;
        [self.naviImpl popToRootViewModelWithAnimation:YES];
        return [RACSignal empty];
    }];
    
    self.shareCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self share];
        
        return [RACSignal empty];
    }];
    
    self.refreshCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SHOW_SVP(@"加载中");
        RACSignal *signal = [WTKRequestManager  postDicDataWithURL:self.typeArray[self.selectType] withpramater:@{}];
        [signal subscribeNext:^(id x) {
            [SVProgressHUD dismiss];
            self.titleDic = x[@"comment_count"];
            NSArray *array = x[@"comment_list"];
            NSMutableArray *mAarray = [NSMutableArray array];
            for (NSDictionary *aDic in array)
            {
                WTKComment *comment = [[WTKComment alloc]init];
                [comment setValuesForKeysWithDictionary:aDic];
                [mAarray addObject:comment];
            }
            self.dataDic[self.typeArray[self.selectType]] = mAarray;
            self.commentArray = mAarray;
            UITableView *tableView = input;
            if (tableView.mj_header.isRefreshing)
            {
                [tableView.mj_header endRefreshing];
            }
        }];
        return signal;
    }];
    
    self.menuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.selectType = [input integerValue];
        if (self.dataDic[self.typeArray[self.selectType]])
        {///如果有，则不再请求
            self.commentArray = self.dataDic[self.typeArray[self.selectType]];
        }
        else
        {
            [self.refreshCommand execute:[[UITableView alloc]init]];
        }
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


#pragma mark - lazyLoad

- (NSArray *)typeArray
{
    if (!_typeArray)
    {
        _typeArray = @[@"AllComment",@"GoodComment",@"MidComment",@"BadComment",@"PicComment"];
    }
    return _typeArray;
}
- (NSDictionary *)titleDic
{
    if (!_titleDic)
    {
        _titleDic = @{@"whole":@"0",
                      @"good":@"0",
                      @"middle":@"0",
                      @"bad":@"0",
                      @"picture":@"0"};
    }
    return _titleDic;
}
- (NSMutableArray *)commentArray
{
    if (!_commentArray)
    {
        _commentArray = @[].mutableCopy;
    }
    return _commentArray;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic)
    {
        _dataDic = @{}.mutableCopy;
    }
    return _dataDic;
}

@end
