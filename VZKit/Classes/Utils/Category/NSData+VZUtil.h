//
//  NSData+VZUtil.h
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import <Foundation/Foundation.h>

@interface NSData (VZUtil)

- (NSData *)aesEncrypt:(NSString *)key;

- (NSData *)aesDecrypt:(NSString *)key;

@end
