//
//  VZResponseCache.h
//  VZKit
//
//  Created by VonZen on 2017/7/18.
//

#import <Foundation/Foundation.h>

@interface VZResponseCache : NSObject

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (id<NSCoding>)objectForKey:(NSString *)key; 

- (void)trimToDate:(NSDate *)date;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects; 

@end
