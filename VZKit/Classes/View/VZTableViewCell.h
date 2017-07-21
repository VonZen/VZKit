//
//  VZTableViewCell.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <UIKit/UIKit.h>
#import "VZCellDelegate.h"

@interface VZTableViewCell : UITableViewCell<VZCellDelegate>

@property (nonatomic, assign) float separatorHeight;
 
@property (nonatomic, strong, readonly) UIView *separator;
@property (nonatomic, strong, readonly) UIImageView *indicator;
 
@end
