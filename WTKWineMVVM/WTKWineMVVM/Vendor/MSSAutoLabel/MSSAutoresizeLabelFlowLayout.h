//
//  MSSAutoresizeLabelFlowLayout.h
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSSAutoresizeLabelFlowLayoutDelegate <NSObject>

@optional

- (void)layoutFinishWithNumberOfline:(NSInteger)number;

@end

@protocol MSSAutoresizeLabelFlowLayoutDataSource <NSObject>

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MSSAutoresizeLabelFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <MSSAutoresizeLabelFlowLayoutDataSource> dataSource;
@property (nonatomic,weak) id <MSSAutoresizeLabelFlowLayoutDelegate> delegate;

@end
