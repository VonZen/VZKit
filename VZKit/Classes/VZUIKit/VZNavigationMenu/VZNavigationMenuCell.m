//
//  VZNavigationMenuCell.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZNavigationMenuCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+VZUtil.h"

@implementation VZNavigationMenuCell
{
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubview];
    }
    
    return self;
}

- (void)createSubview
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(14);
    }];
}

- (void)setData:(NSString *)data
{
    _titleLabel.text = data;
}
@end
