//
//  VZDownloadManager.h
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZDownloader.h"

#define kNotificationVZAddDownloadTask            @"kNotificationVZAddDownloadTask"

@interface VZDownloadManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong          ) void(^backgroundTransferCompletionHandler)();

@property (nonatomic, copy            ) NSString   *downloadDirectory;

@property (nonatomic, assign, readonly) NSUInteger downloadCount;

@property (nonatomic, assign, readonly) NSUInteger currentDownloadsCount;

@property (nonatomic                  ) BOOL       startImmediatly;

@property (nonatomic                  ) BOOL       backgroundMode;

@property (nonatomic, readonly, copy) NSArray *downloadedTask;

@property (nonatomic, readonly, copy) NSArray *downloadingTask;


- (BOOL)downloadFileWithUrl:(NSString *)url
                   withName:(NSString *)name
                   withIcon:(NSString *)iconUrl
                andDelegate:(id<VZDownloaderDelegate>)delegate
                      error:(NSError **)error;


- (void)downloadFileWithResumeData:(NSData *)resumeData
                          withName:(NSString *)name
                       andDelegate:(id<VZDownloaderDelegate>)delegate;

- (void)restoreDownloadTaskWithDelegate:(id<VZDownloaderDelegate>)delegate;

- (NSArray *)currentDownloadsFilteredByState:(NSURLSessionTaskState)state;

- (void)setMaxDownloadingCount:(NSInteger)maxDownloadingCount;

- (void)resumeDownloadTaskWithUrl:(NSString *)url;

- (void)removeDownloadTaskWithUrl:(NSString *)url;

- (void)removeAllDownloadTask;

- (BOOL)hasTaskWithUrl:(NSString *)url;

- (void)resumeAllDownload;

- (void)saveResumeDataToFile;

- (void)closeDownloadServer;

- (VZDownloader *)getCurrentInstallInterrupted:(NSString *)name;

@end
