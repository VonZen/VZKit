//
//  VZSearchHistoryCell.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZSearchHistoryCell.h"
#import "UIColor+VZUtil.h"
#import <Masonry/Masonry.h>
#import "VZControlCreator.h"

@interface VZSearchHistoryCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation VZSearchHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self createSubview];
    }
    
    return self;
}

- (void)setData:(NSString *)string
{
    self.label.text = string;
}

- (void)createSubview
{
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.separator];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.deleteButton.mas_left).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14+8, 14+8));
    }];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5*[UIScreen mainScreen].bounds.size.width/320.0);
    }];
}

- (UILabel *)label
{
    if (!_label) {
        _label = [VZControlCreator createLabelWithTitle:@""
                                              WithColor:@"#333333"
                                           withFontSize:14];
    }
    
    return _label;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [VZControlCreator createButtonWithImage:@"icon_history_delete" withSelected:@"icon_history_delete_selected"];
        [_deleteButton addTarget:self action:@selector(deleteHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

- (void)deleteHistoryItem:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHistoryCell:)]) {
        [self.delegate deleteHistoryCell:self];
    }
}
@end
