//
//  WTKAboutMeTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKAboutMeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *w_Label;
@property (weak, nonatomic) IBOutlet UIImageView *w_imageView;
@property (weak, nonatomic) IBOutlet UILabel *w_subLabel;

- (void)updateWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
