//
//  VZViewModelService.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>

@class VZBaseViewModel;

@interface VZViewModelService : NSObject

- (instancetype)initWithNavigation:(UINavigationController *)navigationController;

- (void)pushViewModel:(__kindof VZBaseViewModel *)viewModel;

- (void)popViewModelWithAnimated:(BOOL)animated;

- (void)popToRootViewModel;

- (void)presentViewModel:(__kindof VZBaseViewModel *)viewModel;

- (void)dismissViewModelWithAnimated:(BOOL)animated;

@end
