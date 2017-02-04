//
//  UIImage+SplitImageIntoTwoParts.m
//  TapRepublic
//
//  Created by Terry Lin on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define SAWTOOTH_COUNT 10
#define SAWTOOTH_WIDTH_FACTOR 20 
#import "UIImage+SplitImageIntoTwoParts.h"

@implementation UIImage (SplitImageIntoTwoParts)

+(NSArray *)splitImageIntoTwoParts:(UIImage *)image
{    
    CGFloat scale = [[UIScreen mainScreen] scale]; 
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    CGFloat width,height,widthgap,heightgap;
    int piceCount = SAWTOOTH_COUNT;
    width = image.size.width;
    height = image.size.height;
    widthgap = width/SAWTOOTH_WIDTH_FACTOR;
    heightgap = height/piceCount;
    //    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextRef context;
    CGImageRef imageMasked;
    UIImage *leftImage,*rightImage;
    
    //part one
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, 0, 0);
    int a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, 0, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [image drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    leftImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:leftImage];
    UIGraphicsEndImageContext();
    
    //part two
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    CGContextMoveToPoint(context, width, 0);
    a=-1;
    for (int i=0; i<piceCount+1; i++) {
        CGContextAddLineToPoint(context, width/2+(widthgap*a), heightgap*i);
        a= a*-1;
    }
    CGContextAddLineToPoint(context, width, height);
    CGContextClosePath(context);
    CGContextClip(context);
    [image drawAtPoint:CGPointMake(0, 0)];
    imageMasked = CGBitmapContextCreateImage(context);
    rightImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    [array addObject:rightImage];
    UIGraphicsEndImageContext();
    
    
    return array;
}
@end
