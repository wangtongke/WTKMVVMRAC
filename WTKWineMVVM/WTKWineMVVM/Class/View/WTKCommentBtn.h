//
//  WTKCommentBtn.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/2.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKCommentBtn : UIButton

@property(nonatomic,strong)UIColor  *w_titleColor;

/**
 * 构建方法
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                       subTitle:(NSString *)subTitle;

///重设title
- (void)setTitle:(NSString *)title
        subTitle:(NSString *)subTitle;

@end
