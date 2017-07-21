//
//  VZListViewModel.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZBaseViewModel.h"

@interface VZListViewModel : VZBaseViewModel

@property (nonatomic, strong) RACCommand *listViewDidSelectCommand;

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldInfiniteScrolling;

@property (nonatomic, assign) BOOL isLoadCompleted;

@property (nonatomic, strong, readonly) RACCommand *fetchDataCommand;

- (RACSignal *)fetchDataSignalWithPage:(NSUInteger)page;

@property (nonatomic, assign) NSUInteger defaultPageIndex;

@end
