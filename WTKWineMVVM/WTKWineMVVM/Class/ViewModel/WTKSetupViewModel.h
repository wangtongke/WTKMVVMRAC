//
//  WTKSetupViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKSetupViewModel : WTKBasedViewModel

@property(nonatomic,strong)RACSubject *cellClickSubject;

@property(nonatomic,strong)RACSubject *exitSubject;

@end
