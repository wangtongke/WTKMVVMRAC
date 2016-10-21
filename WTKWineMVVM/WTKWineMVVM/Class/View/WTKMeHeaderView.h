//
//  WTKMeHeaderView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/13.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKMeViewModel;
@interface WTKMeHeaderView : UIView
@property (strong, nonatomic) UIImageView   *w_headImage;
@property (strong, nonatomic) UILabel       *w_nickNameLabel;
@property (strong, nonatomic) UILabel       *w_phoneNum;
@property (strong, nonatomic) UILabel       *w_collecLabel;
@property (strong, nonatomic) UILabel       *w_historyLabel;
@property (strong, nonatomic) UIImageView   *w_noLoginHead;
@property (strong, nonatomic) UIImageView   *w_right;

@property(nonatomic,strong)   WTKMeViewModel*viewModel;

/**刷新，根据是否登录*/
- (void)update;

@end
