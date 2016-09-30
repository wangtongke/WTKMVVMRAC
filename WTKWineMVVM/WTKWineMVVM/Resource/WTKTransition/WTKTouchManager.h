//
//  WTKTouchManager.h
//  WTKTransitionAnimation
//
//  Created by 王同科 on 16/9/29.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WTKTouchManager : NSObject

@property(nonatomic,assign)CGPoint touchPoint;

@property(nonatomic,assign)float radius;

+ (instancetype)shareManager;

@end
