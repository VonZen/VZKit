//
//  VZListViewDelegate.h
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import <Foundation/Foundation.h>

@protocol VZListViewDelegate <NSObject>



- (void)reloadData:(id)sender;
- (void)reloadData;

- (void)handleDataUpdate:(RACTuple *)tuple;

- (void)cellSelectAfter:(NSIndexPath *)indexPath;

- (float)sectionHeight; 

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath withObject:(id)object;
@end
