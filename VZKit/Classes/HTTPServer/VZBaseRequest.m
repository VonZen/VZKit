//
//  VZBaseRequest.m
//  Pods
//
//  Created by VonZen on 2017/7/19.
//
//

#import "VZBaseRequest.h"
#import "VZNetworkServer.h"

@implementation VZBaseRequest

- (void)request:(VZRequestCompletionBlock)complete
{
    self.completeBlock = complete;
    
    [[VZNetworkServer sharedInstance] request:self];
}

- (void)request:(VZRequestCompletionBlock)complete
   withProgress:(VZUploadProgressBlock)progress
{
    self.completeBlock = complete;
    self.uploadProgressBlock = progress;
    
    [[VZNetworkServer sharedInstance] request:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"";
}

- (NSTimeInterval)cacheInterval
{
    return 0;
}

- (NSTimeInterval)requestTimeout
{
    return 15;
}

- (NSDictionary *)requestParam
{
    return [NSDictionary dictionary];
}

- (BOOL)requestIndicatorVisible
{
    return YES;
}

- (VZRequestMethod)requestMethod
{
    return VZRequestMethodGET;
} 

- (VZRequestSerializerType)requestSerializerType
{
    return VZRequestSerializerTypeHTTP;
}

- (NSDictionary *)requestHeader
{
    return nil;
}

- (NSDictionary *)uploadDataDict
{
    return nil;
}

- (BOOL)isResponseOkWithDict:(NSDictionary *)dict
{
    return YES;
}

- (NSString *)responseMsgWithDict:(NSDictionary *)dict
{
    return @"";
}
@end
