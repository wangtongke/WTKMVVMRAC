//
//  WTKMeBtn.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKMeBtn : UIButton

/**
 *  左上的提示
 */
@property(nonatomic,assign)NSInteger bageValue;
/**
 * 构建方法  最低高度65
 */
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
