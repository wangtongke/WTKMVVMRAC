//
//  WTKLoginViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKLoginViewModel : WTKBasedViewModel

@property(nonatomic,strong)NSString     *phoneNum;

@property(nonatomic,strong)NSString     *codeNum;

@property(nonatomic,strong)RACSignal    *phoneSignal;

@property(nonatomic,strong)RACSignal    *canLoginSignal;

/**是否可以点击发送验证码*/
@property(nonatomic,strong)RACSignal    *canCodeSignal;

@property(nonatomic,strong)RACCommand   *codeCommand;

@property(nonatomic,strong)RACCommand   *loginCommand;

@end
