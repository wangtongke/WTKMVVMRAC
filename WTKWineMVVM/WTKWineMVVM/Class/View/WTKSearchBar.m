//
//  WTKSearchBar.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSearchBar.h"

@implementation WTKSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    _searchBar      = [[UISearchBar alloc]initWithFrame:CGRectMake(0, -1, kWidth - 160, 30)];
    _searchBar.placeholder       = @"搜索";
    _searchBar.backgroundColor   = WTKCOLOR(255, 255, 255, 0);
    _searchBar.tintColor         = WTKCOLOR(255, 255, 255, 0);
    _searchBar.backgroundColor      = [UIColor clearColor];
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0] size:CGSizeMake(kWidth - 160, 30)] forState:UIControlStateNormal];
    for (UIView *subview in _searchBar.subviews) {
        for(UIView* grandSonView in subview.subviews){
            if ([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                grandSonView.backgroundColor = WTKCOLOR(255, 255, 255, 0);
                grandSonView.alpha = 0;
            }else if([grandSonView isKindOfClass:NSClassFromString(@"UISearchBarTextField")] ){
                grandSonView.backgroundColor = WTKCOLOR(200, 200, 200, 0.6);
                NSLog(@"Keep textfiedld bkg color");
            }else{
//                grandSonView.backgroundColor = [UIColor whiteColor];
                grandSonView.backgroundColor = WTKCOLOR(255, 255, 255, 0);
//                grandSonView.alpha          = 0.6;
            }
        }//for cacheViews
    }
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:WTKCOLOR(253, 253, 253, 1) forKeyPath:@"_placeholderLabel.textColor"];
    
    [self addSubview:_searchBar];
    self.backgroundColor      = [UIColor clearColor];
    
    self.layer.cornerRadius   = 5;
    self.layer.masksToBounds  = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
