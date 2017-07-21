//
//  VZCollectionViewCell.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZCollectionViewCell.h"
#import "VZAlignmentLabel.h"
#import "Masonry.h"
#import "UIColor+VZUtil.h"
#import "VZControlCreator.h"

@interface VZCollectionViewCell ()

@property (nonatomic, strong, readwrite) VZAlignmentLabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *desp1Label;
@property (nonatomic, strong, readwrite) UILabel *desp2Label;
@property (nonatomic, strong, readwrite) UIImageView *icon; 

@end

@implementation VZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubview];
    }
    
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[VZAlignmentLabel alloc] init];
        _titleLabel.verticalAlignment = VZVerticalAlignmentTop; 
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _titleLabel;
}

- (UILabel *)desp1Label
{
    if (!_desp1Label) {
        _desp1Label = [VZControlCreator createLabelWithTitle:@""
                                                   WithColor:@"#333333"
                                                withFontSize:12];
    }
    
    return _desp1Label;
}

- (UILabel *)desp2Label
{
    if (!_desp2Label) {
        _desp2Label = [VZControlCreator createLabelWithTitle:@""
                                                   WithColor:@"#333333"
                                                withFontSize:12];
    }
    
    return _desp2Label;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    
    return _icon;
}

@end
