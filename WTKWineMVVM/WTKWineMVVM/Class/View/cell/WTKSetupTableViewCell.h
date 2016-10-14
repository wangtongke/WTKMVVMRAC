//
//  WTKSetupTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKSetupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *w_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *w_imageView;

/**
 * 刷新
 */
- (void)updateTitle:(NSString *)title subTitle:(NSString *)subtitle;

@end
