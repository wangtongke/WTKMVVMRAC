//
//  WTKBasedViewController.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTKViewModelNavigationImpl.h"
@interface WTKBasedViewController : UIViewController
@property(nonatomic,strong,readonly)WTKBasedViewModel *viewModel;
@property(nonatomic,strong,readonly)UIPercentDrivenInteractiveTransition *interactivePopTransition;


- (instancetype)initWithViewModel:(WTKBasedViewModel *)viewModel;

- (void)bindViewModel;

@end
