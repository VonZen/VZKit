//
//  VZListViewController.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZBaseViewController.h"
#import "VZListViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "UIColor+VZUtil.h" 
#import "VZListViewDelegate.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface VZListViewController : VZBaseViewController
<VZListViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, copy) NSString *emptyContentTips;

@property (nonatomic, assign) BOOL isNetworkError;

@property (nonatomic, assign) BOOL  isNotFirstInitData;

@property (nonatomic, strong) MJRefreshStateHeader *refreshHeader;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) __kindof UIScrollView *listView;

@end
