//
//  WTKCommentTableViewCell.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTKComment;
@interface WTKCommentTableViewCell : UITableViewCell

///刷新cell
- (void)updateWithComment:(WTKComment *)comment;

@end
