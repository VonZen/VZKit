//
//  VZMenuCollectionView.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <UIKit/UIKit.h>
#import "VZNavigationMenuConfig.h"

@protocol VZMenuCollectionViewDelegate <NSObject>

- (void)didBackgroundTap;

- (void)didSelectItemAtIndex:(NSUInteger)index;

@end

@interface VZMenuCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items withConfig:(VZNavigationMenuConfig *)config;

@property (nonatomic, weak) id <VZMenuCollectionViewDelegate> delegate;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) VZNavigationMenuConfig *config;

- (void)show;
- (void)hide:(BOOL)animated;



@end
