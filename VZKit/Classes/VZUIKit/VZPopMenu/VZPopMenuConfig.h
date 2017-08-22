//
//  VZPopMenuConfig.h
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import <Foundation/Foundation.h>

#define kDefaultMargin                     4.f
#define kDefaultMenuTextMargin             6.f
#define kDefaultMenuIconMargin             6.f
#define kDefaultMenuCornerRadius           5.f
#define kDefaultAnimationDuration          0.2

#define kDefaultMenuFont                   [UIFont systemFontOfSize:14.f]
#define kDefaultMenuWidth                  120.f
#define kDefaultMenuIconSize               24.f
#define kDefaultMenuRowHeight              40.f
#define kDefaultMenuBorderWidth            0.8
#define kDefaultMenuArrowWidth             8.f
#define kDefaultMenuArrowHeight            10.f
#define kDefaultMenuArrowWidth_R           12.f
#define kDefaultMenuArrowHeight_R          12.f
#define kDefaultMenuArrowRoundRadius       4.f

#define kDefaultTintColor                  [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.f]
#define kDefaultTextColor                  [UIColor whiteColor]
#define kDefaultBackgroundColor            [UIColor clearColor]

@interface VZPopMenuConfig : NSObject

@property (nonatomic, assign) CGFloat menuTextMargin;
@property (nonatomic, assign) CGFloat menuIconMargin;
@property (nonatomic, assign) CGFloat menuRowHeight;
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL ignoreImageOriginalColor;
@property (nonatomic, assign) BOOL allowRoundedArrow;
@property (nonatomic, assign) NSTimeInterval animationDuration;

+ (VZPopMenuConfig *)defaultConfiguration;

@end
