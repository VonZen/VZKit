//
//  VZBaseViewModel.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>
#import "VZViewModelService.h"
#import "ReactiveObjC.h"

@interface VZBaseViewModel : NSObject

- (instancetype)initWithService:(VZViewModelService *)service;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, readonly) VZViewModelService *service;

@property (nonatomic, strong) RACCommand *dismissCommand;

@property (nonatomic, assign) BOOL shouldFetchDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *errors;

- (void)initialize;

@end
