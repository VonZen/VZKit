//
//  VZSearchHistoryCell.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <VZKit/VZTableViewCell.h>

@class VZSearchHistoryCell;
@protocol VZSearchHistoryCellDelegate <NSObject>

- (void)deleteHistoryCell:(FsSearchHistoryCell *)cell;

@end

@interface VZSearchHistoryCell : VZTableViewCell

@property (nonatomic, weak) id<VZSearchHistoryCellDelegate> delegate;

- (void)setData:(NSString *)string;

@end
