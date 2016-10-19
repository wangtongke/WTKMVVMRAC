//
//  WTKPsdManagerViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKPsdManagerViewModel : WTKBasedViewModel
/**原密码*/
@property(nonatomic,copy)NSString     *w_originPsd;
/**新密码*/
@property(nonatomic,copy)NSString     *w_newPsd;
/**确定*/
@property(nonatomic,copy)NSString     *w_confirmPsd;

/**是否可以更改*/
@property(nonatomic,strong)RACSignal    *canSignal;

/**确认修改*/
@property(nonatomic,strong)RACCommand   *confirmCommand;

@end
