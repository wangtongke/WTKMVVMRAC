//
//  WTKQRCodeViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/16.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKQRCodeViewModel : WTKBasedViewModel

@property(nonatomic,strong)RACCommand       *scanCommand;

@end
