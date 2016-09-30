//
//  WTKUser.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKUser : NSObject<NSCoding>

///是否开启指纹验证
@property(nonatomic,assign)BOOL isTouchID;

///角标
@property(nonatomic,assign)NSInteger bageValue;


@property(nonatomic,copy)NSString *bid;


+ (instancetype)currentUser;



@end
