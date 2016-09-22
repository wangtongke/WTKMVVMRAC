//
//  WTKRequestManager.h
//  ZHBMVVM
//
//  Created by 王同科 on 16/9/7.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKRequestManager : NSObject

//+ (instancetype)shareManager;
+ (RACSignal *)postArrayDataWithURL:(NSString *)urlString
                       withpramater:(NSDictionary *)paremater;

+ (RACSignal *)postDicDataWithURL:(NSString *)urlString
                       withpramater:(NSDictionary *)paremater;

+ (RACSignal *)getWithURL:(NSString *)uslString
            withParamater:(NSDictionary *)paramter;
@end
