//
//  VZNetworkServer.h
//  Pods
//
//  Created by VonZen on 2017/7/19.
//
//

#import <Foundation/Foundation.h>
#import "VZBaseRequest.h"

@interface VZNetworkServer : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *cid;

- (void)request:(__kindof VZBaseRequest *)request;

- (void)cancelCurrentUploadTask;

@end
