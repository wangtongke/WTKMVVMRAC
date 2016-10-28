//
//  WTKAddressTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *w_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *w_addresslabel;

@property(nonatomic,strong)RACSubject   *subject;

- (void)updateAddress:(WTKAddress *)address;

@end
