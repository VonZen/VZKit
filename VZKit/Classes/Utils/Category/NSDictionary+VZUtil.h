//
//  NSDictionary+VZUtil.h
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VZUtil)

+ (instancetype)dictionaryInURL:(NSString *)url;

+ (instancetype)dictionaryFromJsonString:(NSString *)JSONString;

@end
