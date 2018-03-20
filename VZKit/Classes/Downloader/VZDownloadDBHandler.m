//
//  VZDownloadDBHandler.m
//  VZKit_Tests
//
//  Created by VonZen on 20/03/2018.
//  Copyright © 2018 davonzhou@live.com. All rights reserved.
//

#import "VZDownloadDBHandler.h"
#import "FMDB/FMDB.h"

@implementation VZDownloadDBHandler
{
    FMDatabase *_db;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDB];
    }
    
    return self;
}

- (void)openDB
{
    if (!_db) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = paths[0];
        NSString *dbPath = [NSString stringWithFormat:@"%@/downloadDB.db", docDir];
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    
    [_db open];
    [self createTable];
}

- (void)closeDB
{
    [_db close];
}

- (void)createTable
{
    if ([_db tableExists:@"download"]) {
        return;
    }
    
    NSString *tableSqlString = @"CREATE TABLE IF NOT EXISTS download(\
    uid INTEGER PRIMARY KEY AUTOINCREMENT,\
    url TEXT UNIQUE NOT NULL,\
    iconUrl TEXT, \
    name TEXT,\
    fileName TEXT, \
    downloadDirectory TEXT,\
    startTime double, \
    endTime double,\
    downloadedSize INT8,\
    fileSize INT8,\
    finish INTEGER,\
    resultingFilePath TEXT)";
    if ([_db executeUpdate:tableSqlString]) {
        NSLog(@"create table succ");
    }else{
        NSLog(@"create table fail");
    }
}

- (void)addItem:(VZDownloader *)downloader
{
    
    NSString *insertSql = @"INSERT INTO download(\
    url, iconUrl, name, fileName, downloadDirectory, \
    startTime, endTime, downloadedSize, fileSize, finish, resultingFilePath) \
    VALUES(:url, :iconUrl, :name, :fileName, :downloadDirectory,\
    :startTime, :endTime, :downloadedSize, :fileSize, :finish, :resultingFilePath)";
    if ([_db executeUpdate:insertSql,
         downloader.url,
         downloader.icon,
         downloader.name,
         downloader.fileName,
         downloader.downloadDirectory,
         @(downloader.startTime),
         @0.0,
         @0LL,
         @0LL,
         @(downloader.finished),
         downloader.resultingFilePath]) {
        NSLog(@"insert sql succ");
    }
}

- (void)updateItem:(VZDownloader *)downloader
{
    [_db executeUpdate:@"UPDATE download SET\
     url=?, iconUrl=?, name=?, fileName=?, downloadDirectory=?, startTime=?, endTime=?, downloadedSize=?, fileSize=?, finish=?, resultingFilePath=? \
     WHERE url = ?", downloader.url, downloader.icon, downloader.name, downloader.fileName, downloader.downloadDirectory,
     @(downloader.startTime),
     @(downloader.endTime),
     @(downloader.downloadedFileSize),
     @(downloader.fileSize),
     @(downloader.finished),
     downloader.resultingFilePath,
     downloader.url];
}

- (void)deleteItem:(VZDownloader *)downloader
{
    [_db executeUpdate:[NSString stringWithFormat:@"delete from download where url='%@'", downloader.url]];
}

- (NSArray *)getListWithFinish:(BOOL)finish
{
    NSArray *array = [NSArray new];
    FMResultSet* resultSet = [_db executeQuery:@"select * from download where finish=? ORDER BY endTime DESC", finish ? @1 : @0];
    if (resultSet && resultSet.columnCount>0) {
        NSMutableArray *mutableArray = [NSMutableArray new];
        while ([resultSet next]) {
            VZDownloader *downloader = [VZDownloader new];
            downloader.url = [resultSet stringForColumn:@"url"];
            downloader.icon = [resultSet stringForColumn:@"iconUrl"];
            downloader.name = [resultSet stringForColumn:@"name"];
            downloader.fileName = [resultSet stringForColumn:@"fileName"];
            downloader.downloadDirectory = [resultSet stringForColumn:@"downloadDirectory"];
            downloader.startTime = [resultSet doubleForColumn:@"startTime"];
            downloader.endTime = [resultSet doubleForColumn:@"endTime"];
            downloader.downloadedFileSize = [resultSet longLongIntForColumn:@"downloadedSize"];
            downloader.fileSize = [resultSet longLongIntForColumn:@"fileSize"];
            downloader.finished = [resultSet boolForColumn:@"finish"];
            downloader.resultingFilePath = [resultSet stringForColumn:@"resultingFilePath"];
            [mutableArray addObject:downloader];
        }
        array = [[NSArray alloc] initWithArray:mutableArray];
    }
    
    return array;
}

- (NSArray *)allList
{
    NSArray *array = [NSArray new];
    FMResultSet* resultSet = [_db executeQuery:@"select * from download"];
    if (resultSet && resultSet.columnCount>0) {
        NSMutableArray *mutableArray = [NSMutableArray new];
        while ([resultSet next]) {
            VZDownloader *downloader = [VZDownloader new];
            downloader.url = [resultSet stringForColumn:@"url"];
            downloader.icon = [resultSet stringForColumn:@"iconUrl"];
            downloader.name = [resultSet stringForColumn:@"name"];
            downloader.fileName = [resultSet stringForColumn:@"fileName"];
            downloader.downloadDirectory = [resultSet stringForColumn:@"downloadDirectory"];
            downloader.startTime = [resultSet doubleForColumn:@"startTime"];
            downloader.endTime = [resultSet doubleForColumn:@"endTime"];
            downloader.downloadedFileSize = [resultSet longLongIntForColumn:@"downloadedSize"];
            downloader.fileSize = [resultSet longLongIntForColumn:@"fileSize"];
            downloader.finished = [resultSet boolForColumn:@"finish"];
            downloader.resultingFilePath = [resultSet stringForColumn:@"resultingFilePath"];
            [mutableArray addObject:downloader];
        }
        array = [[NSArray alloc] initWithArray:mutableArray];
    }
    
    return array;
}

- (VZDownloader *)getItemByUrl:(NSString *)url
{
    FMResultSet* resultSet = [_db executeQuery:[NSString stringWithFormat:@"select * from download where url='%@'", url]];
    if (resultSet && resultSet.columnCount>0) {
        while ([resultSet next]) {
            VZDownloader *downloader = [VZDownloader new];
            downloader.url = [resultSet stringForColumn:@"url"];
            downloader.icon = [resultSet stringForColumn:@"iconUrl"];
            downloader.name = [resultSet stringForColumn:@"name"];
            downloader.fileName = [resultSet stringForColumn:@"fileName"];
            downloader.downloadDirectory = [resultSet stringForColumn:@"downloadDirectory"];
            downloader.startTime = [resultSet doubleForColumn:@"startTime"];
            downloader.endTime = [resultSet doubleForColumn:@"endTime"];
            downloader.downloadedFileSize = [resultSet longLongIntForColumn:@"downloadedSize"];
            downloader.fileSize = [resultSet longLongIntForColumn:@"fileSize"];
            downloader.finished = [resultSet boolForColumn:@"finish"];
            downloader.resultingFilePath = [resultSet stringForColumn:@"resultingFilePath"];
            return downloader;
        }
    }
    
    return nil;
}

- (VZDownloader *)getCurrentInstallInterrupted:(NSString *)name
{
    NSArray *array = [self getListWithFinish:YES];
    for (VZDownloader *item in array) {
        if ([item.name isEqualToString:name]) {
            return item;
        }
    }
    
    return nil;
}

- (void)deleteAll
{
    //TODO:
}
@end
