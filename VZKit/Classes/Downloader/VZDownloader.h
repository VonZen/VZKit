//
//  VZDownloader.h
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, FsDownloadError) {
    VZDownloadErrorInvalidURL = 0,
    VZDownloadErrorHTTPError,
    VZDownloadErrorNotEnoughFreeDiskSpace
};

@class VZDownloader;

@protocol VZDownloaderDelegate <NSObject>

- (void)download:(VZDownloader *)downloader
     didProgress:(float)progress
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

- (void)download:(VZDownloader *)downloader
didFinishWithError:(NSError *)error
        location:(NSURL *)location;


@end

@interface VZDownloader : NSObject

@property (nonatomic, weak) id<VZDownloaderDelegate> delegate;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, readwrite) float                    progress;

@property (nonatomic, strong   ) NSString                 *name;

@property (nonatomic, strong   ) NSString                 *fileName;

@property (nonatomic           ) NSTimeInterval           startTime;

@property (nonatomic           ) NSTimeInterval           endTime;

@property (nonatomic, strong   ) NSString                 *icon;

@property (nonatomic, strong   ) NSString                 *url;

@property (nonatomic           ) int64_t                  downloadedFileSize;

@property (nonatomic           ) int64_t                  fileSize;

@property (nonatomic           ) BOOL                     finished;

@property (nonatomic,strong    ) NSString                 *resultingFilePath;

@property (nonatomic,strong    ) NSString                 *downloadDirectory;

@property (nonatomic           ) NSData                   *resumeData;

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                         toDirectory:(NSString *)directory
                        withFileName:(NSString *)fileName
                             withUrl:(NSString *)url
                            withName:(NSString *)name
                            withIcon:(NSString *)icon
                            delegate:(id<VZDownloaderDelegate>)delegate;

- (void)cancel;
- (void)suspend;
- (void)resume;
- (void)cancelWithResumeDate:(void (^)(NSData *resumeData))completionHandler;
@end
