//
//  VZCollectionViewController.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZCollectionViewController.h"
#import "VZListViewModel.h"
#import "VZCollectionViewCell.h" 
#import "UIColor+VZUtil.h"

@interface VZCollectionViewController ()

@property (nonatomic, strong) VZListViewModel *viewModel;  

@property (nonatomic, strong) UICollectionView *listView;

@end

@implementation VZCollectionViewController

@dynamic viewModel;

@synthesize listView = _listView;

- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        self.cellClass = [VZCollectionViewCell class];
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

- (UICollectionView *)listView{
    if (!_listView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = [self itemSize];
        
        _listView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.layer.masksToBounds = YES;
        _listView.layer.cornerRadius = 10;
        _listView.contentInset = [self contentInset];
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView registerClass:self.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
    }
    
    return _listView;
}

- (CGSize)itemSize{
    return CGSizeZero;
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsZero;
}

- (void)reloadData
{
    [self.listView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *ci =NSStringFromClass(self.cellClass);
    UITableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ci forIndexPath:indexPath];
    
    id object = self.viewModel.dataSource[indexPath.row];
    [self configureCollectionViewCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.viewModel.listViewDidSelectCommand execute:indexPath];
    
    [self cellSelectAfter:indexPath];
}

@end
