//
//  WTKBingProtocol.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTKBindProtocol <NSObject>
///绑定viewModel
- (instancetype)bindViewModel:(id)viewModel;
@end
