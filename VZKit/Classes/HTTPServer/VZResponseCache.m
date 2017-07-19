//
//  VZResponseCache.m
//  VZKit
//
//  Created by VonZen on 2017/7/18.
//

#import "VZResponseCache.h" 

@interface VZResponseCache()

@property (nonatomic, strong) NSCache *memoryCache;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, copy) NSString *cachePath;

@property (nonatomic, strong) dispatch_queue_t queue; 

@end

@implementation VZResponseCache

- (instancetype)init{
    if (self = [super init]) {
        _memoryCache = [[NSCache alloc] init];
        _fileManager = [NSFileManager defaultManager];
        _queue = dispatch_queue_create([@"VZHttpServerFileCacheQueue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Public
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key{
    NSString *encodedKey = [self encodedString:key];
    [self.memoryCache setObject:object forKey:key];
    dispatch_async(self.queue, ^{
        NSString *filePath = [self.cachePath stringByAppendingPathComponent:encodedKey];
        BOOL written = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
        if (!written) {
            NSLog(@"VZHttpServer: save respnse object to file failed");
        }
    });
}

- (id<NSCoding>)objectForKey:(NSString *)key{
    NSString *encodedKey = [self encodedString:key];
    id<NSCoding> object = [self.memoryCache objectForKey:encodedKey];
    if (!object) {
        NSString *filePath = [self.cachePath stringByAppendingPathComponent:encodedKey];
        if ([self.fileManager fileExistsAtPath:filePath]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
    }
    
    return object;
} 

- (void)trimToDate:(NSDate *)date{
    __autoreleasing NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:self.cachePath]
                                                   includingPropertiesForKeys:@[NSURLContentModificationDateKey]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    if (error) {
        NSLog(@"VZHttpServer: get files error:%@", error);
        return;
    }
    
    dispatch_async(self.queue, ^{
        for (NSURL *fileUrl in files) {
            NSDictionary *dictionary = [fileUrl resourceValuesForKeys:@[NSURLContentModificationDateKey] error:nil];
            NSDate *modificationDate = [dictionary objectForKey:NSURLContentModificationDateKey];
            
            if (modificationDate.timeIntervalSince1970 - date.timeIntervalSince1970 < 0) {
                NSError *error;
                [self.fileManager removeItemAtURL:fileUrl error:&error];
            }
        }
    });
}


- (void)removeObjectForKey:(NSString *)key{
    NSString *encodedKey = [self encodedString:key];
    [self.memoryCache removeObjectForKey:key];
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:encodedKey];
    if ([self.fileManager fileExistsAtPath:filePath]) {
        __autoreleasing NSError *error = nil;
        BOOL removed = [self.fileManager removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"VZHttpServer: remove item failed with error:%@", error);
        }
    }
}

- (void)removeAllObjects
{
    [self.memoryCache removeAllObjects];
    __autoreleasing NSError *error;
    BOOL removed = [self.fileManager removeItemAtPath:_cachePath error:&error];
    if (!removed) {
        NSLog(@"VZHttpServer: remove cache directory failed with error:%@", error);
    }
}

#pragma mark - Private
- (NSString *)encodedString:(NSString *)string{
    if (!string.length) {
        return @"";
    }
    
    CFStringRef static const charsToEscape = CFSTR(",:/");
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        charsToEscape,
                                                                        kCFStringEncodingUTF8);
    
    return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)decodedString:(NSString *)string{
    if (!string.length) {
        return @"";
    }
    
    CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef)string,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)unescapedString;
}

#pragma mark - Property
- (NSString *)cachePath{
    if (!_cachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = paths[0];
        _cachePath = [cachePath stringByAppendingPathComponent:@"requestCacheDirectory"];
        BOOL isDirectory;
        if (![self.fileManager fileExistsAtPath:_cachePath isDirectory:&isDirectory]) {
            __autoreleasing NSError *error = nil;
            BOOL created = [ self.fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (!created) {
                NSLog(@"VZHttpServer: create cache directory failed with error:%@", error);
            }
        }
    }
    
    return _cachePath;
}
@end
