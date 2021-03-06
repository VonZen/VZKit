//
//  UIColor+VZUtil.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "UIColor+VZUtil.h"

@implementation UIColor (VZUtil)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [UIColor colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //remove whitespace and \n convert to uppercase;
    NSString *cString = [color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].uppercaseString;
    // String should be 7 characters
    if (cString.length == 7 && [cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
        
        NSRange range = NSMakeRange(0, 2);
        NSString *redString = [cString substringWithRange:range];
        range.location = 2;
        NSString *greenString = [cString substringWithRange:range];
        range.location = 4;
        NSString *blueString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int red, green, blue;
        [[NSScanner scannerWithString:redString] scanHexInt:&red];
        [[NSScanner scannerWithString:greenString] scanHexInt:&green];
        [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
        return [UIColor colorWithRed:((float)red / 255.0f) green:((float)green / 255.0f) blue:((float)blue / 255.0f) alpha:alpha];
    }
    else
    {
        return [UIColor clearColor];
    }
}

@end
