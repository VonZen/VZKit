//
//  VZCellDelegate.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>

@protocol VZCellDelegate <NSObject>

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *desp1Label;
@property (nonatomic, strong, readonly) UILabel *desp2Label;
@property (nonatomic, strong, readonly) UIImageView *icon;

- (void)createSubview;

- (void)setModel:(id)model;

@end
