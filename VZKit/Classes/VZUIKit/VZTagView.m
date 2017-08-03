//
//  VZTagView.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZTagView.h"
#import "UIColor+VZUtil.h"
#import "UIImage+VZUtil.h"

@interface VZTagView()

@property (nonatomic, readwrite) float viewHeight;

@end

@implementation VZTagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _dataSource = @[];
        
        _tagMargin = 10;
        _tagPadding = 10;
        _titleSize = 14;
        _TintColor = [UIColor colorWithHexString:@"#333333"];
        _borderColor = [UIColor colorWithHexString:@"#e6e6e6"];
        _specialTintColor = [UIColor colorWithHexString:@"#ff7648"];
        _selectedBackgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    
    return self;
}

- (void)initContent{
    float buttonHeight = self.tagMargin * 2 + self.titleSize;
    
    int   rowLeftMargin = 0;
    int   columnIndex = 0;
    float currentButtonMargin = 0;
    int num = 0;
    
    for (int i = 0; i< self.dataSource.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:self.titleSize];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = buttonHeight/2.0;
        
        button.layer.borderWidth = 1;
        
        [button setTitle:self.dataSource[i].title forState:UIControlStateNormal];
        
        if (self.dataSource[i].isSpecial) {
            [button setTitleColor:self.specialTintColor forState:UIControlStateNormal];
            button.layer.borderColor = self.specialTintColor.CGColor;
        }else{
            [button setTitleColor:self.tintColor forState:UIControlStateNormal];
            button.layer.borderColor = self.borderColor.CGColor;
        }
        
        [button setBackgroundImage:[UIImage createImageFromColor:self.selectedBackgroundColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage createImageFromColor:self.selectedBackgroundColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize titleSize = [self.dataSource[i].title boundingRectWithSize:CGSizeMake(self.bounds.size.width - self.tagMargin * 2, self.titleSize)
                                                       options:NSStringDrawingTruncatesLastVisibleLine
                            | NSStringDrawingUsesLineFragmentOrigin
                            | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleSize]}
                                                       context:nil].size;
        
        rowLeftMargin = rowLeftMargin + titleSize.width + self.tagMargin + self.tagPadding * 2;
        if (rowLeftMargin > self.bounds.size.width) {
            rowLeftMargin = titleSize.width + self.tagPadding * 2;
            columnIndex++;
            currentButtonMargin = titleSize.width + self.tagPadding * 2;
            num = 0;
            button.frame = CGRectMake(self.tagMargin, self.tagMargin + (buttonHeight + self.tagMargin)*columnIndex, titleSize.width + self.tagPadding * 2, buttonHeight);
        }else{
            button.frame = CGRectMake(self.tagMargin*(num + 1) + currentButtonMargin, self.tagMargin + (buttonHeight + self.tagMargin)*columnIndex, titleSize.width + self.tagPadding * 2, buttonHeight);
            currentButtonMargin += titleSize.width + self.tagPadding * 2;
        }
        num++;
        [self addSubview:button];
    }
    self.viewHeight = (self.dataSource.count > 0) ? (columnIndex +1)*buttonHeight + self.tagMargin*(columnIndex+2): 0;
}


- (void)buttonTaped:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagTaped:)]) {
        [self.delegate tagTaped:button.tag];
    }
}
@end
