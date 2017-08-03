//
//  VZNavigationMenuConfig.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <Foundation/Foundation.h>

@interface VZNavigationMenuConfig : NSObject

+ (instancetype)defaultConfig;

@property (nonatomic, copy)  NSString *cellClassName;

@property (nonatomic, assign) NSUInteger maxCountOfItemInRow;

@property (nonatomic, assign) float menuWidth;

@property (nonatomic, assign) float itemHeight;

@property (nonatomic, assign) float itemMargin;

@property (nonatomic, assign) float animationDuration;

@property (nonatomic, assign) float selectionSpeed;

@property (nonatomic, assign) float backgroundAlpha;

@property (nonatomic, assign) float menuAlpha;

@property (nonatomic, strong) UIImage *arrowImage;

@property (nonatomic, assign) float arrowPadding;

@property (nonatomic, strong) UIColor *mainColor; 
@end
