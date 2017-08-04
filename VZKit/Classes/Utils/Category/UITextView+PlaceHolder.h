//
//  UITextView+PlaceHolder.h
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
