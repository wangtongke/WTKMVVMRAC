//
//  WTKTextView.h
//  WTKTextView
//
//  Created by 王同科 on 16/10/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKTextView : UITextView

@property(nonatomic,copy)NSString *placeholder;

/**
 *  构建方法
 */
+ (instancetype)textView;

@end
