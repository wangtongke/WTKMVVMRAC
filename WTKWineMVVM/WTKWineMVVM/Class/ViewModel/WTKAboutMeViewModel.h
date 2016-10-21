//
//  WTKAboutMeViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
#import "WTKAboutMeVC.h"
@interface WTKAboutMeViewModel : WTKBasedViewModel

@property(nonatomic,strong)RACCommand   *cellClickCommand;

@property(nonatomic,weak)WTKAboutMeVC   *vc;

@end
