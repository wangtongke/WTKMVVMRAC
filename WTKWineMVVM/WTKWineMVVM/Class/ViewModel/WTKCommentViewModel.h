//
//  WTKCommentViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
@class WTKOrderModel;
@class WTKCommentVC;
@interface WTKCommentViewModel : WTKBasedViewModel

@property(nonatomic,strong)WTKOrderModel    *order;

@property(nonatomic,weak)WTKCommentVC       *vc;

@property(nonatomic,strong)RACCommand       *addPicCommand;

@property(nonatomic,strong)RACCommand       *commitCommand;

@property(nonatomic,strong)RACSubject       *changeImgSubject;

///评论
@property(nonatomic,copy)NSString           *comment;

@end
