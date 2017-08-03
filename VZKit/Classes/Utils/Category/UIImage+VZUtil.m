//
//  UIImage+VZUtil.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "UIImage+VZUtil.h"

@implementation UIImage (VZUtil)

+ (UIImage *)createImageFromColor:(UIColor *)color
{
    return [self createImageFromColor:color size:CGSizeMake(10, 10)];
}

+ (UIImage *)createImageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
