//
//  VZPopMenuConfig.m
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import "VZPopMenuConfig.h"

@implementation VZPopMenuConfig

+ (VZPopMenuConfig *)defaultConfiguration
{
    static dispatch_once_t once = 0;
    static VZPopMenuConfig *configuration;
    dispatch_once(&once, ^{ configuration = [[VZPopMenuConfig alloc] init]; });
    return configuration;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuRowHeight = kDefaultMenuRowHeight;
        self.menuWidth = kDefaultMenuWidth;
        self.textColor = kDefaultTextColor;
        self.textFont = kDefaultMenuFont;
        self.tintColor = kDefaultTintColor;
        self.borderColor = kDefaultTintColor;
        self.borderWidth = kDefaultMenuBorderWidth;
        self.textAlignment = NSTextAlignmentLeft;
        self.ignoreImageOriginalColor = NO;
        self.allowRoundedArrow = NO;
        self.menuTextMargin = kDefaultMenuTextMargin;
        self.menuIconMargin = kDefaultMenuIconMargin;
        self.animationDuration = kDefaultAnimationDuration;
    }
    return self;
}
@end
