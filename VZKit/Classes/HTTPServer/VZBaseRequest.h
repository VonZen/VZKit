//
//  VZBaseRequest.h
//  Pods
//
//  Created by VonZen on 2017/7/19.
//
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger, VZRequestMethod) {
    VZRequestMethodGET = 0,
    VZRequestMethodPOST,
    VZRequestMethodPOSTWithFile
};

typedef NS_ENUM(NSInteger, VZRequestSerializerType) {
    VZRequestSerializerTypeHTTP = 0,
    VZRequestSerializerTypeJSON
};

@class VZBaseRequest;

typedef void(^VZRequestCompletionBlock) (__kindof VZBaseRequest *request);

typedef void(^VZUploadProgressBlock) (float progress);

@interface VZBaseRequest : NSObject

@property (nonatomic) Class responseClass;

@property (nonatomic, strong) id  responseObject;

@property (nonatomic, assign) BOOL  isResponseFromCache;

@property (nonatomic, copy) NSDictionary  *responseDict; 

@property (nonatomic, assign) BOOL  requestIndicatorVisible;

@property (nonatomic, strong) NSError *responseError;

@property (nonatomic, assign) BOOL  retCodeOk;

@property (nonatomic, copy) NSString *responseErrorInfoFromDomain;

@property (nonatomic, copy) VZRequestCompletionBlock completeBlock;

@property (nonatomic, copy) VZUploadProgressBlock uploadProgressBlock;

- (void)request:(VZRequestCompletionBlock)complete;

- (void)request:(VZRequestCompletionBlock)complete
   withProgress:(VZUploadProgressBlock)progress;

#pragma mark - Methods need to be overwrite or not
- (NSString *)requestUrl;


/**
 default: 15s;
 */
- (NSTimeInterval)requestTimeout;

/**
 For Get requests only;
 unit: second；
 default 0;
 */
- (NSTimeInterval)cacheInterval;

/**
 default: @{};
 */
- (NSDictionary *)requestParam;

/**
 default: VZRequestMethodGET
 */
- (VZRequestMethod)requestMethod; 

/**
 default: VZRequestSerializerTypeHTTP
 */
- (VZRequestSerializerType)requestSerializerType;

/**
 default: nil
 */
- (NSDictionary *)requestHeader;

/**
 default: nil
 */
- (NSDictionary *)uploadDataDict;

- (BOOL)isResponseOkWithDict:(NSDictionary *)dict;

- (NSString *)responseMsgWithDict:(NSDictionary *)dict;
@end
