//
//  VZBaseViewModel.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZBaseViewModel.h"

@interface VZBaseViewModel ()

@property (nonatomic, readwrite) VZViewModelService *service;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@end

@implementation VZBaseViewModel

- (instancetype)initWithService:(VZViewModelService *)service
{
    if (self = [super init]) {
        _service = service;
        _shouldFetchDataOnViewDidLoad = YES;
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [self.service dismissViewModelWithAnimated:YES];
        
        return [RACSignal empty];
    }];
}

- (RACSubject *)errors {
    if (!_errors)
    {
        _errors = [RACSubject subject];
    }
    
    return _errors;
}
@end
