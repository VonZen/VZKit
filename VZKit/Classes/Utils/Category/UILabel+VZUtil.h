//
//  UILabel+VZUtil.h
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import <UIKit/UIKit.h>

@interface UILabel (VZUtil)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
