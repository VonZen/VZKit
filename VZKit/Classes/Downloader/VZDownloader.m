//
//  VZDownloader.m
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import "VZDownloader.h"

@implementation VZDownloader

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                         toDirectory:(NSString *)directory
                        withFileName:(NSString *)fileName
                             withUrl:(NSString *)url
                            withName:(NSString *)name
                            withIcon:(NSString *)icon
                            delegate:(id<VZDownloaderDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.downloadTask = downloadTask;
        self.downloadDirectory = directory;
        self.fileName = fileName;
        self.delegate =delegate;
        self.icon = icon;
        self.name = name;
        self.url = url;
    }
    
    return self;
}

- (void)cancel
{
    [self.downloadTask cancel];
}

- (void)suspend
{
    [self.downloadTask suspend];
}

- (void)resume
{
    [self.downloadTask resume];
}

- (void)cancelWithResumeDate:(void (^)(NSData *resumeData))completionHandler
{
    [self.downloadTask cancelByProducingResumeData:completionHandler];
}


- (BOOL)isValidResumeData:(NSData *)data{
    if (!data || data.length < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    NSString *localFilePath = resumeDictionary[@"NSURLSessionResumeInfoLocalPath"];
    if (localFilePath.length < 1) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}
@end
