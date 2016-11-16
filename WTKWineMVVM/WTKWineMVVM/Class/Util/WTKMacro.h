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
#define WTKLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) {}
#define WTKLog(...);
#endif

#pragma mark - 宽高

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define ZOOM_SCALL kWidth/375.0

#define IMG_URL @"http://www.jiuyunda.net:90"

///userDefaults

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define CURRENT_USER [WTKUser currentUser]

#define SHOPPING_MANAGER [WTKShoppingManager manager]

///SVP
#define SHOW_SVP(title) \
[SVProgressHUD showWithStatus:title];

#define SHOW_ERROE(title) \
[SVProgressHUD showErrorWithStatus:title];

#define SHOW_SUCCESS(title) \
[SVProgressHUD showSuccessWithStatus:title];

#define DISMISS_SVP(time) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
[SVProgressHUD dismiss]; \
});


#endif /* WTKMacro_h */
