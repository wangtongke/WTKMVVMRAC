//
//  UILabel+WTK.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "UILabel+WTK.h"

@implementation UILabel (WTK)
-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    self.attributedText = str;
}

-(void) setText:(NSString *)text Font:(UIFont *)font withColor:(UIColor *)color Range:(NSRange)range withColor:(UIColor *)color1 Range:(NSRange)range1
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    self.attributedText = str;
}
@end
