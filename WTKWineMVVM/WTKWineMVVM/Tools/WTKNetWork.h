//
//  WTKNetWork.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKNetWork : NSObject

@property(nonatomic,assign)BOOL isNetReachable;

+ (instancetype)shareInatance;

- (void)initNetWork;

@end
