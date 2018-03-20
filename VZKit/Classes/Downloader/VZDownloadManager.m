//
//  VZDownloadManager.m
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZDownloadManager.h"
#import "VZDownloadDBHandler.h"

@interface VZDownloadManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, assign, readwrite) NSUInteger          downloadCount;

@property (nonatomic, assign, readwrite) NSUInteger          currentDownloadsCount;

@property (nonatomic, strong, readwrite) NSOperationQueue    *operationQueue;

@property (nonatomic, strong           ) NSURLSession        *session;

@property (nonatomic, strong           ) NSURLSession        *backgroundSession;

@property (nonatomic, strong, readwrite) NSMutableDictionary *downloadTaskDict;

@end

@implementation VZDownloadManager
{
    VZDownloadDBHandler *_dbHandler;
}

+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    
    return sharedInstance;
}

- (instancetype)init{
   @throw [NSException exceptionWithName:@"init error"
                                  reason:@"it is a singleton. use sharedInstance"
                                userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate
{ 
    if ([super init]) {
        [self moveOldDataToNewFilePath];
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:self
                                                delegateQueue:self.operationQueue];
        NSURLSessionConfiguration *backgroundSessionConfiguration;
        backgroundSessionConfiguration =[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSBundle mainBundle].bundleIdentifier];
        self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration
                                                               delegate:self
                                                          delegateQueue:self.operationQueue];
        self.downloadTaskDict = [[NSMutableDictionary alloc] init];
        self.downloadDirectory =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"app"];
        self.backgroundMode = NO;
        self.startImmediatly = YES;
        
        BOOL isDir;
        BOOL needCreateDir = false;
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.downloadDirectory isDirectory:&isDir]) {
            if (!isDir) {
                needCreateDir = YES;
            }
        }else{
            needCreateDir = YES;
        }
        
        if (needCreateDir) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _dbHandler = [[VZDownloadDBHandler alloc] init];
        
    }
    
    return self;
}

//temp: move down data to new save position
- (void)moveOldDataToNewFilePath
{
    NSString *oldDataPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"app"];
    NSString *newDataPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"app"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldDataPath]) {
        NSArray *dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:oldDataPath error:nil];
        if (dataArray && dataArray.count >0) {
            [[NSFileManager defaultManager] moveItemAtPath:oldDataPath toPath:newDataPath error:nil];
        }
    }
}

- (void)restoreDownloadTaskWithDelegate:(id<VZDownloaderDelegate>)delegate
{
    NSArray *allDownloadTask = [_dbHandler allList];
    for (VZDownloader *downloader in allDownloadTask) {
        self.downloadTaskDict[downloader.url] = downloader;
        if (!downloader.finished) {
            downloader.delegate = delegate;
            
        }
        
    }
}

- (NSUInteger)downloadCount
{
    return self.downloadTaskDict.allKeys.count;
}

- (NSUInteger)currentDownloadsCount
{
    NSArray *array = [self currentDownloadsFilteredByState:NSURLSessionTaskStateRunning];
    return array.count;
}

- (void)setMaxDownloadingCount:(NSInteger)maxDownloadingCount
{
    self.operationQueue.maxConcurrentOperationCount = maxDownloadingCount;
}

- (void)resumeDownloadTaskWithUrl:(NSString *)url
{
    VZDownloader *downloader = self.downloadTaskDict[url];
    
    if (downloader.downloadTask && downloader.resumeData) {
        // current session
        downloader.downloadTask = [self.session downloadTaskWithResumeData:downloader.resumeData];
        [downloader resume];
    }else{ // app restart
        NSString *tdFileName = [NSString stringWithFormat:@"%@.td", downloader.fileName];
        NSString *tdFilePath = [NSString stringWithFormat:@"%@/app/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], tdFileName];
        NSData *oldResumeData = [NSData dataWithContentsOfFile:tdFilePath];
        
        if (oldResumeData) {
            downloader.resumeData = oldResumeData;
            downloader.downloadTask = [self.session downloadTaskWithResumeData:downloader.resumeData];
        }else{
            downloader.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downloader.url]];
        }
        [downloader resume];
    }
}

- (void)removeDownloadTaskWithUrl:(NSString *)url
{
    VZDownloader *downloader = self.downloadTaskDict[url];
    [downloader cancel];
    [self.downloadTaskDict removeObjectForKey:url];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:downloader.resultingFilePath error:&error];
    [_dbHandler deleteItem:downloader];
}

- (void)removeAllDownloadTask
{
    [self.downloadTaskDict removeAllObjects];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    for (NSString *file in [fileManager subpathsAtPath:self.downloadDirectory]) {
        [fileManager removeItemAtPath:[self.downloadDirectory stringByAppendingPathComponent:file] error:&error];
    }
}

- (BOOL)downloadFileWithUrl:(NSString *)url
                   withName:(NSString *)name
                   withIcon:(NSString *)iconUrl
                andDelegate:(id<VZDownloaderDelegate>)delegate
                      error:(NSError **)error
{
    NSURL *URL = [NSURL URLWithString:url];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        NSError *errorTemp = [[NSError alloc] initWithDomain:@"com.funshion.tvcontroller"
                                                        code:VZDownloadErrorInvalidURL
                                                    userInfo:nil];
        if(error != nil){
            *error = errorTemp;
        }
        
        return NO;
    }
    
    NSString *fileName = url.lastPathComponent;
    if (!name || [name isEqualToString:@""]) {
        name = fileName;
    }
    if (!iconUrl || [iconUrl isEqualToString:@""]) {
        iconUrl = @"";
    }
    
    NSURLSessionDownloadTask *downloadTask;
    if (self.backgroundMode) {
        downloadTask = [self.backgroundSession downloadTaskWithURL:URL];
    } else {
        downloadTask = [self.session downloadTaskWithURL:URL];
    }
    VZDownloader *downloader = [[VZDownloader alloc] initWithDownloadTask:downloadTask
                                                              toDirectory:self.downloadDirectory
                                                             withFileName:fileName
                                                                  withUrl:url
                                                                 withName:name
                                                                 withIcon:iconUrl
                                                                 delegate:delegate];
    
//    downloader.startTime = [FsCommonFunc getCurrentTimestamp];
    downloader.progress = 0;
    [self downloadWithDownloader:downloader];
    
    return YES;
}

//TODO: exit app, then Resume Download Task
- (void)downloadFileWithResumeData:(NSData *)resumeData
                          withName:(NSString *)name
                       andDelegate:(id<VZDownloaderDelegate>)delegate
{
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    VZDownloader *downloader = [[VZDownloader alloc] initWithDownloadTask:downloadTask
                                                              toDirectory:self.downloadDirectory
                                                             withFileName:name
                                                                  withUrl:@""
                                                                 withName:@""
                                                                 withIcon:@""
                                                                 delegate:delegate];
    downloader.progress = 0;
    [self downloadWithDownloader:downloader];
}

- (void)downloadWithDownloader:(VZDownloader *)downloader
{
    self.downloadTaskDict[downloader.url] = downloader;
    if (self.startImmediatly) {
        [downloader resume];
    }
    [_dbHandler addItem:downloader];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVZAddDownloadTask object:downloader];
}


- (NSArray *)currentDownloadsFilteredByState:(NSURLSessionTaskState)state
{
    NSMutableArray *array = [NSMutableArray new];
    NSArray *values = (self.downloadTaskDict).allValues;
    for (VZDownloader *downloader in values) {
        if (downloader.downloadTask.state == state) {
            [array addObject:downloader];
        }
    }
    
    return [[NSArray alloc] initWithArray:array];
}

- (NSArray *)getDownloadedTask
{
    return [_dbHandler getListWithFinish:YES];
}

- (NSArray *)getDownloadingTask
{
    NSMutableArray *downloadingArray = [NSMutableArray new];
    for (VZDownloader *downloader in self.downloadTaskDict.allValues) {
        if (!downloader.finished) {
            [downloadingArray addObject:downloader];
        }
    }
    
    return downloadingArray;
}

- (BOOL)hasTaskWithUrl:(NSString *)url
{
    VZDownloader *downloader = [_dbHandler getItemByUrl:url];
    
    return downloader ? YES : NO;
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // complete a download task
    VZDownloader *downloader = self.downloadTaskDict[downloadTask.originalRequest.URL.absoluteString];
    
    NSError *error;
    NSURL *resultingURL;
    
    NSString *fileStr = [[NSString stringWithFormat:@"%@/app", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]] stringByAppendingPathComponent:downloader.fileName];
    if([[NSFileManager defaultManager] replaceItemAtURL:[NSURL fileURLWithPath:fileStr]
                                          withItemAtURL:location
                                         backupItemName:nil
                                                options:NSFileManagerItemReplacementUsingNewMetadataOnly
                                       resultingItemURL:&resultingURL
                                                  error:&error]){
        downloader.resultingFilePath = resultingURL.path;
        downloader.downloadedFileSize = downloader.fileSize;
        downloader.progress = 1;
        downloader.finished = YES;
//        downloader.endTime = [FsCommonFunc getCurrentTimestamp];
        [_dbHandler updateItem:downloader];
    }else{
        downloader.error = error;
//        downloader.endTime = [FsCommonFunc getCurrentTimestamp];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    // update download task progress
    VZDownloader *downloader = self.downloadTaskDict[downloadTask.originalRequest.URL.absoluteString];
    
    float progress = totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown ? -1 :(totalBytesWritten/(float)totalBytesExpectedToWrite);
    NSLog(@"%.2f",progress);
    downloader.progress = progress;
    downloader.downloadedFileSize = totalBytesWritten;
    downloader.fileSize = totalBytesExpectedToWrite;
    
    if (downloader.delegate && [downloader.delegate respondsToSelector:@selector(download:didProgress:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [downloader.delegate download:downloader
                          didProgress:progress
                    totalBytesWritten:totalBytesWritten
            totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Resume a download task
    NSLog(@"Resume at offset:%lld, total expected:%lld", fileOffset, expectedTotalBytes);
}

//NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    VZDownloader *downloader = self.downloadTaskDict[task.originalRequest.URL.absoluteString];
    NSError *downloadError = error ? error : downloader.error;
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (![self validateResponse:(NSHTTPURLResponse *)task.response]
            && (downloadError == nil || downloadError.domain == NSURLErrorDomain)) {
            downloadError = [[NSError alloc] initWithDomain:@"com.funshion.tvcontroller"
                                                       code:VZDownloadErrorHTTPError
                                                   userInfo:nil];
        }
    }
    if (downloader.delegate && [downloader.delegate respondsToSelector:@selector(download:didFinishWithError:location:)]) {
        [downloader.delegate download:downloader
                   didFinishWithError:downloadError
                             location:nil];
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    [session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> *dataTasks, NSArray<NSURLSessionUploadTask *> *uploadTasks, NSArray<NSURLSessionDownloadTask *> *downloadTasks) {
        if (downloadTasks.count == 0) {
            if (self.backgroundTransferCompletionHandler) {
                void(^completionHander)(void) = self.backgroundTransferCompletionHandler;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completionHander();
                    
                    UILocalNotification *locationNotification = [[UILocalNotification alloc] init];
                    locationNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:locationNotification];
                }];
                
                self.backgroundTransferCompletionHandler = nil;
            }
        }
    }];
}

#pragma mark - other

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
{
    NSRange range = NSMakeRange(200, 99);
    
    return NSLocationInRange(response.statusCode, range);
}

- (void)resumeAllDownload
{
    for (VZDownloader *downloader in (self.downloadTaskDict).allValues) {
        if (!downloader.finished) {
            if (downloader.downloadTask && downloader.resumeData) {
                // current session
                downloader.downloadTask = [self.session downloadTaskWithResumeData:downloader.resumeData];
                [downloader resume];
            }else{ // app restart
                NSString *tdFileName = [NSString stringWithFormat:@"%@.td", downloader.fileName];
                NSString *tdFilePath = [NSString stringWithFormat:@"%@/app/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], tdFileName];
                NSData *oldResumeData = [NSData dataWithContentsOfFile:tdFilePath];
                
                if (oldResumeData) {
                    downloader.resumeData = oldResumeData;
                    downloader.downloadTask = [self.session downloadTaskWithResumeData:downloader.resumeData];
                }else{
                    downloader.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downloader.url]];
                }
                [downloader resume];
            }
        }
    }
}

- (void)saveResumeDataToFile
{
    for (VZDownloader *downloader in (self.downloadTaskDict).allValues) {
        if (!downloader.finished && downloader.downloadTask && downloader.downloadTask.state == NSURLSessionTaskStateRunning) { //need to improve
            [downloader cancelWithResumeDate:^(NSData *resumeData) {
                downloader.resumeData = resumeData;
                downloader.downloadTask = nil;
                NSString *tdFileName = [NSString stringWithFormat:@"%@.td", downloader.fileName];
                NSString *tdFilePath = [NSString stringWithFormat:@"%@/app/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], tdFileName];
                BOOL isSaved = [[NSFileManager defaultManager] createFileAtPath:tdFilePath contents:resumeData attributes:nil];
                NSLog(@"%d", isSaved);
            }];
        }
    }
}

- (void)closeDownloadServer
{
    [_dbHandler closeDB];
}

- (VZDownloader *)getCurrentInstallInterrupted:(NSString *)name
{
    return [_dbHandler getCurrentInstallInterrupted:name];
}

@end
