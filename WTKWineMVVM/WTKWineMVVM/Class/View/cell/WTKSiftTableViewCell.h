//
//  WTKSiftTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKSiftModel;
@interface WTKSiftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *w_Label;

@property (weak, nonatomic) IBOutlet UIImageView *w_imageView;

- (void)updateWithModel:(WTKSiftModel *)model;

@end
