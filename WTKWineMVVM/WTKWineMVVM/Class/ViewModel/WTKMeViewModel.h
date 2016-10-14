//
//  WTKMeViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKMeViewModel : WTKBasedViewModel
/**cell点击*/
@property(nonatomic,strong)RACSubject   *cellClickSubject;

/**head点击*/
@property(nonatomic,strong)RACSubject   *headClickSubject;

/**设置*/
@property(nonatomic,strong)RACSubject   *setUpSubject;

@end
