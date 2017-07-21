//
//  VZListViewModel.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZListViewModel.h"

@interface VZListViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;

@end

@implementation VZListViewModel

- (instancetype)initWithService:(VZViewModelService *)service
{
    if (self = [super initWithService:service]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.defaultPageIndex = 0;
    self.shouldPullToRefresh = YES;
    self.shouldInfiniteScrolling = YES;
    self.dataSource = @[];
    self.page = 0;
    
    @weakify(self)
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self fetchDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [[self.fetchDataCommand.errors
      filter:[self fetchDataErrorsFilter]]
     subscribe:self.errors];
}

- (BOOL (^)(NSError *error))fetchDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}


- (RACSignal *)fetchDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

@end
