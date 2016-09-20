//
//  WTKBasedViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTKViewModelServices.h"
#import "WTKViewModelNavigationImpl.h"
@interface WTKBasedViewModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong,readonly)id<WTKViewModelServices> services;
@property(nonatomic,strong)WTKViewModelNavigationImpl *naviImpl;
@property (nonatomic, copy, readonly) NSDictionary *params;
- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params;


@end
