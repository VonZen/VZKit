//
//  VZMenuCollectionView.m
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import "VZMenuCollectionView.h" 
#import "VZMenuCellDelegate.h"

@interface VZMenuCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy) NSString *cellClassName;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) float offsetYForAnimate;

@end

@implementation VZMenuCollectionView
{
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items withConfig:(VZNavigationMenuConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        self.config = config ? : [VZNavigationMenuConfig defaultConfig];
        
        self.layer.backgroundColor = self.config.mainColor.CGColor;
        self.clipsToBounds = YES;
        self.offsetYForAnimate = 5;
        endFrame = self.bounds;
        endFrame.origin.y -= self.offsetYForAnimate;
        startFrame = endFrame;
        
        self.selectedIndex = 0;
        
        self.items = items;
        
        NSUInteger itemCount = self.items.count;
        NSInteger rowNum = (itemCount%self.config.maxCountOfItemInRow == 0 ?
                            itemCount/self.config.maxCountOfItemInRow :
                            itemCount/self.config.maxCountOfItemInRow +1);
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        float cellMargin = self.config.itemMargin;
        if (self.config.maxCountOfItemInRow == 1) {
            flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,self.config.itemHeight);
            flowLayout.minimumLineSpacing = 0;
            self.contentInset = UIEdgeInsetsMake(self.offsetYForAnimate,0,0,0);
            startFrame.origin.y -= rowNum *self.config.itemHeight;
            startFrame.size.height = rowNum *self.config.itemHeight +self.offsetYForAnimate;
            endFrame.size.height = rowNum *self.config.itemHeight +self.offsetYForAnimate;
        }else{
            float itemSideLength = ([UIScreen mainScreen].bounds.size.width - (self.config.maxCountOfItemInRow+1)*cellMargin)/self.config.maxCountOfItemInRow;
            flowLayout.itemSize = CGSizeMake(itemSideLength, self.config.itemHeight);
            flowLayout.minimumInteritemSpacing = cellMargin;
            flowLayout.minimumLineSpacing = cellMargin;
            self.contentInset = UIEdgeInsetsMake(cellMargin+self.offsetYForAnimate, cellMargin, cellMargin, cellMargin);
            
            startFrame.origin.y -= rowNum *self.config.itemHeight + cellMargin*(rowNum + 1);
            startFrame.size.height = rowNum *self.config.itemHeight + cellMargin*(rowNum + 1) +self.offsetYForAnimate;
            endFrame.size.height = rowNum *self.config.itemHeight + cellMargin*(rowNum + 1) +self.offsetYForAnimate;
        }
        
        self.cellClassName = self.config.cellClassName;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:startFrame collectionViewLayout:flowLayout];
        self.collectionView.contentInset = self.contentInset;
        [self.collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:self.cellClassName];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    return self;
}

- (void)show
{
    [self addSubview:self.collectionView];
    [UIView animateWithDuration:self.config.animationDuration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.layer.backgroundColor = self.config.mainColor.CGColor;
                         self.collectionView.frame = endFrame;
                     } completion:nil];
}

- (void)hide:(BOOL)animated
{
    [UIView animateWithDuration:animated ?self.config.animationDuration : 0
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.layer.backgroundColor = self.config.mainColor.CGColor;
                         self.collectionView.frame = startFrame;
                     } completion:^(BOOL finished) {
                         currentIndexPath = nil;
                         [self.collectionView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

- (void)hideSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBackgroundTap)]) {
        [self.delegate didBackgroundTap];
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<VZMenuCellDelegate> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellClassName forIndexPath:indexPath];
    
    [cell setData:self.items[indexPath.item]];
    if (indexPath.row == self.selectedIndex) {
        [cell setSelected:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    if (self.selectedIndex != indexPath.row) {
        [[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]] setSelected:NO];
    }
    
    self.selectedIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.item];
    }
    
    [[collectionView cellForItemAtIndexPath:indexPath] setSelected:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(self.collectionView.frame, touchPoint);
}
@end
