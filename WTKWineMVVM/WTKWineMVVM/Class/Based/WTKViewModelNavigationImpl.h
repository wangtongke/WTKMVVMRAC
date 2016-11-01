//
//  WTKViewModelNavigationImpl.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKViewModelNavigationImpl : NSObject<WTKViewModelServices>
@property(nonatomic,copy)NSString *className;
///设置当前rootVC
@property(nonatomic,assign)NSInteger selectedIndex;
- (instancetype)initWithNavigationController:(UINavigationController *)navi;


@end
