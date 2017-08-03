//
//  VZMenuButton.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZMenuButton.h"
#import "VZNavigationMenuConfig.h"

@implementation VZMenuButton
{
    float _padding;
}

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image withImagePadding:(float)padding
{
    if (self = [super initWithFrame:frame]) {
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [self addSubview:self.title];
        
        self.arrow = [[UIImageView alloc] initWithImage:image];
        _padding = padding;
        [self addSubview:self.arrow];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2-6, self.frame.size.height/2);
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.title.frame) + _padding, self.frame.size.height/2);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    
    return YES;
}
@end
