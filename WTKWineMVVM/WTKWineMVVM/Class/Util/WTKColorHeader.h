//
//  WTKColorHeader.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#ifndef WTKColorHeader_h
#define WTKColorHeader_h

#define WTKCOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BASE_COLOR WTKCOLOR(243, 243, 246, 1.0)

#define BACK_COLOR WTKCOLOR(240,240,240,1)


#define BASE_COLOR1 WTKCOLOR(210, 210, 210, 1.0)

#define THEME_COLOR WTKCOLOR(250, 98, 97, 1)

#define THEME_COLOR_ALPHA WTKCOLOR(250, 98, 97, 0.99)

#define BLACK_COLOR WTKCOLOR(50,50,50,1)

#define WORDS_COLOR [UIColor colorWithHex:0x5c5c5c] // 常规文字

#define LINKS_COLOR [UIColor colorWithHex:0x333333] // 链接 (深绿)

#define LINE_COLOR [UIColor colorWithHex:0xe9e9e9]  // 描线色

#endif /* WTKColorHeader_h */
