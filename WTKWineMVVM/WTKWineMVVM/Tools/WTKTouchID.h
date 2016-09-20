//
//  WTKTouchID.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKTouchID : NSObject

+ (void) registTouchIDWithCompleteBlock:(void(^)(NSString *))block;

+ (BOOL) delegateTouchID;

@end
