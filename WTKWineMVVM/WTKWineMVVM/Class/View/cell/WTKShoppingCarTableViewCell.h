//
//  WTKShoppingCarTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKGoodManagerView;
@interface WTKShoppingCarTableViewCell : UITableViewCell

//cell1
@property (weak, nonatomic) IBOutlet UIButton *w_selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *w_goodImageView;

@property (weak, nonatomic) IBOutlet UILabel *w_titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *w_priceLabel;
@property (weak, nonatomic) IBOutlet WTKGoodManagerView *w_managView;


//cell2

@property (weak, nonatomic) IBOutlet UILabel *w_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_addressLabel;

@property(nonatomic,strong)WTKAddress *address;

- (void)updateWithGood:(WTKGood *)good;

@end
