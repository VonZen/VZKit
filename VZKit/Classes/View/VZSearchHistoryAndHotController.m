//
//  VZSearchHistoryAndHotController.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZSearchHistoryAndHotController.h"
#import "VZTagView.h"
#import "VZSearchHistoryCell.h"
#import "VZSearchHistoryAndHotViewModel.h"
#import "UIColor+VZUtil.h"

@interface VZSearchHistoryAndHotController ()<VZSearchHistoryCellDelegate, VZTagViewDelegate>

@property (nonatomic, weak) VZSearchHistoryAndHotViewModel *viewModel;

@property (nonatomic, strong) VZTagView *tagView;

@end

@implementation VZSearchHistoryAndHotController
@dynamic viewModel;

- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        self.emptyContentTips = @"Nothing";
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, searchHistorys) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.viewModel.searchHistorys.count;
    }else{
        return self.viewModel.hotKeywords.count > 0 ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"FsSearchHistoryCell";
        VZSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[VZSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.delegate = self;
        [cell setData:self.viewModel.searchHistorys[indexPath.row]]; 
        
        return cell;
    }else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        VZTagView *tagView = [[VZTagView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        tagView.dataSource = self.viewModel.hotKeywords;
        [tagView initContent];
        [cell.contentView addSubview:tagView];
        tagView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tagView.viewHeight);
        tagView.delegate = self;
        self.tagView = tagView;
        return cell;
    }
}

#pragma mark - FsSearchHistoryCellDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.viewModel.searchHistorys.count >0 ? 45 : 0;
    }else{
        return self.tagView.viewHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.viewModel.searchHistorys.count >0 ? 10 : 0.01;//fix with compatibility
    }else{
        return 47;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 17+20 +10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    dividerView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [view addSubview:dividerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width-15*2, 18+20)];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:17];
    label.text = section == 0 ? @"搜索历史" : @"热门搜索";
    [view addSubview:label];
    
    return view;
}

- (void)tableViewCellSelectAfter:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickedHistoryItem:)]) {
            NSString *keyword = self.viewModel.searchHistorys[indexPath.row];
            [self.delegate clickedHistoryItem:keyword];
        }
    }
}

#pragma mark - FsSearchHistoryCellDelegate
- (void)deleteHistoryCell:(VZSearchHistoryCell *)cell
{
    NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
    [self.viewModel removeHistoryItem:indexPath.row];
}

#pragma mark - FsTagViewDelegate
- (void)tagTaped:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedHotItem:)]) {
        NSString *keyword = self.viewModel.hotKeywords[index];
        [self.delegate clickedHotItem:keyword];
    }
}
@end
