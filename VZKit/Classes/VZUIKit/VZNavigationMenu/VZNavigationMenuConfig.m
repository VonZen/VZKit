//
//  VZNavigationMenuConfig.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZNavigationMenuConfig.h"

@implementation VZNavigationMenuConfig

+ (instancetype)defaultConfig{
    return [self new];
}

- (instancetype)init{
    if (self = [super init]) {
        _cellClassName = @"VZNavigationMenuCell";
        _maxCountOfItemInRow = 3;
        _menuWidth = [UIScreen mainScreen].bounds.size.width;
        _itemHeight = 110.0f;
        _itemMargin = 0.0f;
        _animationDuration = 0.3f;
        _selectionSpeed = 0.15f;
        _backgroundAlpha = 0.6f;
        _menuAlpha = 0.8f;
        _arrowImage = [UIImage imageNamed:@"icon_arrow_down"];
        _arrowPadding = 12.0f;
        _mainColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    
    return self;
} 
@end
