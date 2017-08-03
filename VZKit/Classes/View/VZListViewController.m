//
//  VZListViewController.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZListViewController.h" 

@interface VZListViewController ()

@property (nonatomic, strong) VZListViewModel *viewModel;

@end

@implementation VZListViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        if ([viewModel shouldFetchDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [[[self.viewModel.fetchDataCommand execute:@0] deliverOnMainThread] subscribeNext:^(RACTuple* _Nullable x){
                    self.isNetworkError = NO;
                    
                    [self handleDataUpdate:x];
                }error:^(NSError * _Nullable error) {
                    @strongify(self)
                    if (!self.isNotFirstInitData) {
                        self.isNotFirstInitData = YES;
                        [self.activityView stopAnimating];
                    }
                    
                    self.isNetworkError = YES;
                    [self reloadData];
                }];
            }];
        }
        self.emptyContentTips = @"";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
} 


- (void)createSubview
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    if (self.viewModel.shouldPullToRefresh) {
        self.listView.mj_header = self.refreshHeader;
    }
    
    if (self.viewModel.shouldInfiniteScrolling) {
        self.listView.mj_footer = self.refreshFooter;
    }
}

- (MJRefreshStateHeader *)refreshHeader
{
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData:)];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    
    return _refreshHeader;
}

- (MJRefreshAutoNormalFooter *)refreshFooter
{
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _refreshFooter.refreshingTitleHidden = YES;
    }
    
    return _refreshFooter;
}

- (UIActivityIndicatorView *)activityView{
    if(!_activityView){
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

#pragma mark - DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isNotFirstInitData) {
        return nil;
    }else{
        [self.activityView startAnimating];
        return self.activityView;
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"icon_empty_content"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]};
    if (self.isNetworkError) {
        return [[NSAttributedString alloc] initWithString:@"网络错误" attributes:attributes];
    }else{
        return [[NSAttributedString alloc] initWithString:self.emptyContentTips attributes:attributes];
    }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isNetworkError) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                     NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]};
        
        return [[NSAttributedString alloc] initWithString:@"请检查网络然后点击重试" attributes:attributes];
    }
    
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.isNetworkError) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        return [[NSAttributedString alloc] initWithString:@"重试" attributes:attributes];
    }
    
    return nil;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    BOOL isEmpty = self.viewModel.dataSource.count == 0;
    self.listView.mj_footer.hidden = isEmpty;
    
    return isEmpty;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -80;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self reloadData:button];
}

#pragma mark - refresh trigger
- (void)reloadData:(id)sender
{
    [self.listView.mj_footer resetNoMoreData];
    
    @weakify(self)
    [[[self.viewModel.fetchDataCommand execute:@0] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.page = 0;
        self.isNetworkError = NO;
        
        [self handleDataUpdate:x];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.listView.mj_header endRefreshing];
        self.isNetworkError = YES;
        [self reloadData];
    } completed:^{
        @strongify(self)
        [self.listView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData
{
    @weakify(self)
    [[[self.viewModel.fetchDataCommand execute:@(self.viewModel.page + 1)] deliverOnMainThread] subscribeNext:^(RACTuple*  _Nullable x) {
        @strongify(self)
        self.viewModel.page += 1;
        
        [self handleDataUpdate:x];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.listView.mj_footer endRefreshing];
    } completed:^{
        
    }];
}

#pragma mark - Other
- (float)sectionHeight
{
    return 5;
}

- (void)reloadData
{
    [self.listView reloadData];
}

- (void)handleDataUpdate:(RACTuple *)tuple
{
    if (!self.isNotFirstInitData) {
        self.isNotFirstInitData = YES;
        [self.activityView stopAnimating];
    }
    
    NSNumber * isEnd = tuple.first;
    if (isEnd.boolValue) {
        [self.listView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.listView.mj_footer endRefreshing];
    }
    
    [self reloadData];
}

- (void)cellSelectAfter:(NSIndexPath *)indexPath {}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath withObject:(id)object {}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    if (self.view.superview) {
        [self.view.superview endEditing:YES];
    }
}
@end
