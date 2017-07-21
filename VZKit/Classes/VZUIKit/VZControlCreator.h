//
//  VZControlCreator.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>

@interface VZControlCreator : NSObject

+ (UILabel *)createLabelWithTitle:(NSString *)title WithColor:(NSString *)color withFontSize:(float)fontSize;

+ (UIButton *)createButtonWithImage:(NSString *)image withSelected:(NSString *)selectedImage;

+ (UIButton *)createButtonWithTitle:(NSString *)title;

+ (UIButton *)createPrimaryButtonWithTitle:(NSString *)title;

+ (UIButton *)createSecondButtonWithTitle:(NSString *)title;

+ (UIImage *)createImageFromColor:(UIColor *)color;

+ (UIImage *)createImageFromColor:(UIColor *)color size:(CGSize)size;

+ (UIView *)createDivider; 

+ (CAGradientLayer *)createGradientLayer:(NSString *)startColor withEndColor:(NSString *)endColor;

@end
