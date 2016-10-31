//
//  MSSAutoresizeLabelFlowConfig.m
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "MSSAutoresizeLabelFlowConfig.h"

@implementation MSSAutoresizeLabelFlowConfig

+ (MSSAutoresizeLabelFlowConfig *)shareConfig {
    static MSSAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 2);
        self.lineSpace = 15;
        self.itemHeight = 25;
        self.itemSpace = 15;
        self.itemCornerRaius = 8;
        self.itemColor = [UIColor clearColor];
        self.textMargin = 10;
        self.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        self.textFont = [UIFont wtkNormalFont:15];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
