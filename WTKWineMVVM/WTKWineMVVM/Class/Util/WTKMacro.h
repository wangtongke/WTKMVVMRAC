//
//  WTKMacro.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#ifndef WTKMacro_h
#define WTKMacro_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

///读取用户数据完成
#define READ_USER_DATA_FINISH @"readUserDataFinish"

///------
/// NSLog
///------

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#pragma mark - 宽高

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define ZOOM_SCALL kWidth/375.0





#endif /* WTKMacro_h */
