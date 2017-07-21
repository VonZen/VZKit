//
//  VZViewModelRouter.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZViewModelRouter.h"

@interface VZViewModelRouter ()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation VZViewModelRouter

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (__kindof VZBaseViewController *)viewControllerForViewModel:(__kindof VZBaseViewModel *)viewModel
{
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];

    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MVVM" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    return data ? : @{};
}

@end
