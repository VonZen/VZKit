//
//  VZAlignmentLabel.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZAlignmentLabel.h"

@implementation VZAlignmentLabel
 
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.verticalAlignment = VZVerticalAlignmentMiddle;
    }
    
    return self;
}

- (void)setVerticalAlignment:(VZVerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VZVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VZVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VZVerticalAlignmentMiddle:
            //default.
            break;
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            //default.
            break;
            
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    [super drawTextInRect:actualRect];
}

@end
