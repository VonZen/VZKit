//
//  VZDownloadDBHandler.h
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZDownloader.h"

@interface VZDownloadDBHandler : NSObject

@property (nonatomic, readonly, copy) NSArray *allList;

- (void)closeDB;

- (NSArray *)getListWithFinish:(BOOL)finish;

- (void)deleteAll;

- (void)deleteItem:(VZDownloader *)downloader;

- (void)addItem:(VZDownloader *)downloader;

- (void)updateItem:(VZDownloader *)downloader;

- (VZDownloader *)getItemByUrl:(NSString *)url;

- (VZDownloader *)getCurrentInstallInterrupted:(NSString *)name;
@end
