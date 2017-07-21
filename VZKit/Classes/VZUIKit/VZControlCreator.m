//
//  VZControlCreator.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZControlCreator.h"
#import "UIColor+VZUtil.h"

@implementation VZControlCreator

+ (UILabel *)createLabelWithTitle:(NSString *)title WithColor:(NSString *)color withFontSize:(float)fontSize
{
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:color];
    label.font = [UIFont systemFontOfSize:fontSize];
    
    return label;
}

+ (UIButton *)createButtonWithImage:(NSString *)image withSelected:(NSString *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    
    return button;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 24;
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton *)createPrimaryButtonWithTitle:(NSString *)title
{
    UIButton *button = [VZControlCreator createButtonWithTitle:title];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[VZControlCreator createImageFromColor:[UIColor colorWithHexString:@"#ff7648"]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[VZControlCreator createImageFromColor:[UIColor colorWithHexString:@"#F4734A"]]
                      forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)createSecondButtonWithTitle:(NSString *)title
{
    UIButton *button = [VZControlCreator createButtonWithTitle:title];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithHexString:@"#ff7648"].CGColor;
    
    [button setTitleColor:[UIColor colorWithHexString:@"#ff7648"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#ff7648" alpha:0.5] forState:UIControlStateDisabled];
    [button setBackgroundImage:[VZControlCreator createImageFromColor:[UIColor colorWithHexString:@"#ffffff"]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[VZControlCreator createImageFromColor:[UIColor colorWithHexString:@"#e5e5e5"]]
                      forState:UIControlStateHighlighted];
    [button setBackgroundImage:[VZControlCreator createImageFromColor:[UIColor colorWithHexString:@"#e5e5e5"]]
                      forState:UIControlStateSelected];
    
    return button;
}

+ (UIImage *)createImageFromColor:(UIColor *)color
{
    return [VZControlCreator createImageFromColor:color size:CGSizeMake(100, 100)];
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

+ (UIView *)createDivider
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    return view;
} 

+ (CAGradientLayer *)createGradientLayer:(NSString *)startColor withEndColor:(NSString *)endColor
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:startColor].CGColor, (__bridge id)[UIColor colorWithHexString:endColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    
    return gradientLayer;
}

@end
