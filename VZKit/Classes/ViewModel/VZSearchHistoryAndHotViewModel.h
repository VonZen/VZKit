//
//  VZSearchHistoryAndHotViewModel.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <VZKit/VZListViewModel.h>

@interface VZSearchHistoryAndHotViewModel : VZListViewModel

@property (nonatomic, strong) NSArray *searchHistorys;

@property (nonatomic, copy) NSArray<NSString *> *hotKeywords;

- (void)addHistoryItem:(NSString *)keyword;

- (void)removeHistoryItem:(NSInteger)index;

@end
