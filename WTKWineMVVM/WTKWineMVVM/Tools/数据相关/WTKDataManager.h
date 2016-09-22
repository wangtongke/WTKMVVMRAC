//
//  WTKDataManager.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKDataManager : NSObject

/**
 *程序进入后台，保存用户数据
 */
+ (void)saveUserData;

/**
 *程序进入前台，读取用户数据
 */
+ (void)readUserData;

@end
