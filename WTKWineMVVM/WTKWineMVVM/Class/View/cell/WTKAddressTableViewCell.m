//
//  WTKAddressTableViewCell.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAddressTableViewCell.h"

@interface WTKAddressTableViewCell ()

@property(nonatomic,strong)WTKAddress *address;

@end

@implementation WTKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.subject = [RACSubject subject];
}

- (void)updateAddress:(WTKAddress *)address
{
    self.address            = address;
    self.w_nameLabel.text   = address.w_name;
    self.w_phoneLabel.text  = address.w_phone;
    self.w_addresslabel.text= address.w_address;
}
- (IBAction)w_editBtnClick:(id)sender {
    [self.subject sendNext:@{@"code":@100,@"address":self.address}];
}
- (IBAction)w_deleteBtnClick:(id)sender {
    [self.subject sendNext:@{@"code":@-100,@"address":self.address}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
