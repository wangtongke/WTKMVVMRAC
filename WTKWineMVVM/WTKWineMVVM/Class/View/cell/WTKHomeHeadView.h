//
//  WTKHomeHeadView.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTKHomeHeadView : UICollectionReusableView

@property(nonatomic,strong)NSMutableArray   *dataArray;

@property(nonatomic,strong)RACSubject       *bannerSubject;

@property(nonatomic,strong)RACSubject       *btnSubject;

@end
