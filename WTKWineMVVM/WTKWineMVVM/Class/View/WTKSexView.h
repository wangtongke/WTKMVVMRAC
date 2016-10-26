//
//  WTKSexView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKSexView : UIView

@property(nonatomic,strong)RACSubject *subject;

///性别 YES-男 NO-女
@property(nonatomic,assign)BOOL     w_sex;

@end
