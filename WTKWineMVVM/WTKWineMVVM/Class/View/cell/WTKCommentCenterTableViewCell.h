//
//  WTKCommentCenterTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKOrderModel;
@interface WTKCommentCenterTableViewCell : UITableViewCell
///评价
@property(nonatomic,strong)RACSubject *commentSubject;

- (void)updateWithOrder:(WTKOrderModel *)order;

@end
