//
//  VZTagView.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <UIKit/UIKit.h>

@protocol  VZTagViewDelegate<NSObject>

- (void)tagTaped:(NSInteger)index;

@end

@interface VZTagView : UIView

@property (nonatomic, weak) id<VZTagViewDelegate> delegate;

@property (nonatomic, copy) NSArray<NSString *> *dataSource;

@property (nonatomic, assign) float tagMargin;

@property (nonatomic, assign) float tagPadding;

@property (nonatomic, assign) float titleSize;


/**
 use it after invoke initContent.
 */
@property (nonatomic, readonly) float viewHeight;

@property (nonatomic, strong) UIColor *TintColor;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *specialTintColor;

@property (nonatomic, strong) UIColor *selectedBackgroundColor;

- (void)initContent;

@end
