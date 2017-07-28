//
//  VZTableViewController.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZTableViewController.h"
#import "VZListViewModel.h"
#import "VZTableViewCell.h" 
#import "UIColor+VZUtil.h"

@interface VZTableViewController ()

@property (nonatomic, strong) VZListViewModel *viewModel;

@property (nonatomic, strong) UITableView *listView;

@end

@implementation VZTableViewController

@dynamic viewModel; 

@synthesize listView = _listView;

- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        self.cellClass = [VZTableViewCell class];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Views

- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.multipleTouchEnabled = NO;
        _listView.bouncesZoom = NO;
        _listView.estimatedRowHeight = 50;
        _listView.rowHeight = UITableViewAutomaticDimension;
        _listView.emptyDataSetSource = self;
        _listView.emptyDataSetDelegate = self;
        [_listView registerClass:self.cellClass forCellReuseIdentifier:NSStringFromClass(self.cellClass)];
    }
    
    return _listView;
}

- (void)reloadData
{
    [self.listView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ci =NSStringFromClass(self.cellClass);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ci forIndexPath:indexPath];
    
    id object = self.viewModel.dataSource[indexPath.row];
    [self configureTableViewCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.listViewDidSelectCommand execute:indexPath];
    
    [self cellSelectAfter:indexPath];
}

- (void)cellSelectAfter:(NSIndexPath *)indexPath{}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self sectionHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
 
@end
