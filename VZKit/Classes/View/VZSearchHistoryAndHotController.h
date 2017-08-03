//
//  VZSearchHistoryAndHotController.h
//  VZKit
//
//  Created by VonZen on 2017/8/3.
//

#import <VZKit/VZTableViewController.h>

@protocol VZSearchHistoryAndHotControllerDelegate <NSObject>

- (void)clickedHistoryItem:(NSString *)keyword;

- (void)clickedHotItem:(NSString *)keyword;

@end
@interface VZSearchHistoryAndHotController : VZTableViewController

@property (nonatomic, weak) id<FsProgrammeSearchHotAndHistoryControllerDelegate> delegate; 

@end
