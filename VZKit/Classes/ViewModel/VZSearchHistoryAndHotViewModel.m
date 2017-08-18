//
//  VZSearchHistoryAndHotViewModel.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZSearchHistoryAndHotViewModel.h"

@implementation VZSearchHistoryAndHotViewModel

- (void)initialize
{
    [super initialize];
    self.searchHistorys = [NSMutableArray array];
    self.hotKeywords = @[];
    self.searchHistorys = @[];
    self.dataSource = [@[self.searchHistorys, self.hotKeywords] mutableCopy];
    self.shouldPullToRefresh = NO;
    self.shouldInfiniteScrolling = NO;
    
    [self initSearchHistoryData];
}

- (RACSignal *)fetchDataSignalWithPage:(NSUInteger)page
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { 
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (NSArray<NSString *> *)hotKeywords
{
    return _hotKeywords;
}

#pragma mark - History
- (void)initSearchHistoryData
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *historyArray = [userDefault valueForKey:@"historyArray"];
    if (historyArray) {
        self.searchHistorys = historyArray;
    }
}

- (void)addHistoryItem:(NSString *)keyword
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.searchHistorys];
    NSString *currentKeyword;
    if (tempArray.count>0) {
        for (NSString *str in tempArray) {
            if ([str isEqualToString:keyword]) {
                currentKeyword = str;
            }
        }
        if (currentKeyword) {
            [tempArray removeObject:currentKeyword];
        }
        [tempArray insertObject:keyword atIndex:0];
        
        if (tempArray.count>5) {
            [tempArray removeObject:self.searchHistorys.lastObject];
        }
    }else{
        [tempArray addObject:keyword];
    }
    
    self.searchHistorys = [NSArray arrayWithArray:tempArray];
    
    [self saveHistory];
}

- (void)removeHistoryItem:(NSInteger)index
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.searchHistorys];
    [tempArray removeObjectAtIndex:index];
    self.searchHistorys = [NSArray arrayWithArray:tempArray];
    
    [self saveHistory];
}

- (void)saveHistory
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.searchHistorys forKey:@"historyArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
