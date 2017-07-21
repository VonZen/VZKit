//
//  VZTableViewCell.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZTableViewCell.h"
#import "VZAlignmentLabel.h"
#import <Masonry/Masonry.h>
#import "UIColor+VZUtil.h"
#import "VZControlCreator.h"

@interface VZTableViewCell ()

@property (nonatomic, strong, readwrite) VZAlignmentLabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *desp1Label;
@property (nonatomic, strong, readwrite) UILabel *desp2Label;
@property (nonatomic, strong, readwrite) UIImageView *icon;
@property (nonatomic, strong, readwrite) UIView *separator;
@property (nonatomic, strong, readwrite) UIImageView *indicator;

@end

@implementation VZTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self createSubview];
    }
    
    return self;
}

- (float)separatorHeight
{
    return 5;
}

- (void)createSubview
{
    [self addSubview:self.separator];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.separatorHeight);
    }];
}

- (void)setModel:(id)model{}

//http://stackoverflow.com/questions/14468449/the-selectedbackgroundview-modifies-the-contentview-subviews
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.separator.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.separator.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    }
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

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_next"]];
    }
    
    return _indicator;
}

- (UIView *)separator
{
    if (!_separator) {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    }
    
    return _separator;
}

- (void)bindViewModel:(id)viewModel{}
@end
