//
//  WTKShoppingManager.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKShoppingManager : NSObject<NSCoding>

@property(nonatomic,strong)NSMutableDictionary *goodsDic;

+ (instancetype)manager;

@end
