//
//  VZMenuButton.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <UIKit/UIKit.h>

@interface VZMenuButton : UIControl

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withImagePadding:(float)padding;

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) UILabel *title;

@end
