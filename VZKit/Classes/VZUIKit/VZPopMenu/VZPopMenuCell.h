//
//  VZPopMenuCell.h
//  VZKit
//
//  Created by VonZen on 2017/8/22.
//

#import <UIKit/UIKit.h>

@interface VZPopMenuCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *menuNameLabel;


- (void)setMenuName:(NSString *)menuName withMenuImage:(NSString *)menuImage;

@end
