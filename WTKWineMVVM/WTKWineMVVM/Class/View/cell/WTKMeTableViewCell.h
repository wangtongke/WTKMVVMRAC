//
//  WTKMeTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKMeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *w_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_subTitleLabel;

- (void)updateTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
