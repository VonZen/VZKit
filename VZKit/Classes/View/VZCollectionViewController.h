//
//  VZCollectionViewController.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZListViewController.h"

@interface VZCollectionViewController : VZListViewController
<DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate> 

- (CGSize)itemSize;

- (UIEdgeInsets)contentInset;

@end
