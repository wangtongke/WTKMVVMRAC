//
//  WTKDataManager.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  数据管理类
 */
@interface WTKDataManager : NSObject

/**
 *  保存用户数据
 */
+ (void)saveUserData;

/**
 *  读取用户数据
 */
+ (void)readUserData;

/**
 *  删除用户数据
 */
+ (void)removeUserData;

@end
