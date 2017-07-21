//
//  UIColor+VZUtil.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <UIKit/UIKit.h>

@interface UIColor (VZUtil)

+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 * @param color @“#123456”
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
