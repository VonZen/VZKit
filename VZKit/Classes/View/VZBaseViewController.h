//
//  VZBaseViewController.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <UIKit/UIKit.h>
#import "VZBaseViewModel.h"

@interface VZBaseViewController : UIViewController

- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel;
- (void)back;

- (void)bindViewModel;

- (void)createNavigationBarItem;
- (void)createSubview;

- (void)fingerTapped;

@property (nonatomic, strong) VZBaseViewModel *viewModel;

@end
