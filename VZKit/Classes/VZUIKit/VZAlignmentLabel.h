//
//  VZAlignmentLabel.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, VZVerticalAlignment) {
    VZVerticalAlignmentTop = 0,
    VZVerticalAlignmentMiddle,
    VZVerticalAlignmentBottom,
};

@interface VZAlignmentLabel : UILabel

@property (nonatomic) VZVerticalAlignment verticalAlignment;

@end
