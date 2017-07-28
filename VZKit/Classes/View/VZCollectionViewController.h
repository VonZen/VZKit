//
//  VZCollectionViewController.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZListViewController.h"

@interface VZCollectionViewController : VZListViewController<UICollectionViewDelegate,
UICollectionViewDataSource>

- (CGSize)itemSize;

- (UIEdgeInsets)contentInset;

@end
