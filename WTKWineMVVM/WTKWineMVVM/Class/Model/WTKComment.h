//
//  WTKComment.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 评论
 */
@interface WTKComment : NSObject

@property (nonatomic, copy  ) NSString       *id;
@property (nonatomic, copy  ) NSString       *content;
@property (nonatomic, copy  ) NSString       *type;
@property (nonatomic, assign) NSInteger      star;
@property (nonatomic, assign) NSInteger      hits;
@property (nonatomic, copy  ) NSString       *specification;
@property (nonatomic, copy  ) NSString       *created_at_str;
@property (nonatomic, copy  ) NSString       *customer_id;
@property (nonatomic, copy  ) NSString       *name;
@property (nonatomic, strong) NSMutableArray *pic_thumb_path;
@property (nonatomic, strong) NSMutableArray *pic_path;
@property (nonatomic, copy  ) NSString       *buy_time;
@property (nonatomic, assign) NSInteger      reply_count;
@property (nonatomic, copy  ) NSString       *avatar_url;
@property (nonatomic, copy  ) NSString       *order_completed_time;
@property (nonatomic, copy  ) NSString       *check_status;

@end
