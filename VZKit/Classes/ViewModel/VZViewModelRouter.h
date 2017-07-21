//
//  VZViewModelRouter.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>
#import "VZBaseViewModel.h"
#import "VZBaseViewController.h"

/**
 MVVM.Plist is a router must be used, need to be created in your project
 key: *Controller,
 value: *ViewModel
 */
@interface VZViewModelRouter : NSObject

+ (instancetype)sharedInstance;

- (__kindof VZBaseViewController *)viewControllerForViewModel:(__kindof VZBaseViewModel *)viewModel;

@end
