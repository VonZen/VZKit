//
//  VZNavigationMenu.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <UIKit/UIKit.h>
#import "VZNavigationMenuConfig.h"

@protocol  VZNavigationMenuDelegate<NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface VZNavigationMenu : UIView

@property (nonatomic, weak) id<VZNavigationMenuDelegate> delegate;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, strong) VZNavigationMenuConfig *config;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withConfig:(VZNavigationMenuConfig *)config;

- (void)displayMenuInView:(UIView *)view;

- (void)setTitle:(NSString *)title;

- (void)setDisableWithTitle:(NSString *)title;

- (void)hideMenuWithoutAnimate;

@end
