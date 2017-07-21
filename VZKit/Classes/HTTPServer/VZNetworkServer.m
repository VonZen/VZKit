//
//  VZNetworkServer.m
//  Pods
//
//  Created by VonZen on 2017/7/19.
//
//

#import "VZNetworkServer.h"
#import "VZResponseCache.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@interface VZNetworkServer()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) VZResponseCache *cache;

@property (nonatomic, strong) NSURLSessionDataTask *uploadTask;

@end

@implementation VZNetworkServer

+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        _cache = [[VZResponseCache alloc] init];
    }
    
    return self;
}

#pragma mark - Public
- (void)cancelCurrentUploadTask
{
    if (_uploadTask) {
        [_uploadTask cancel];
        _uploadTask = nil;
    }
}

- (void)request:(VZBaseRequest *)request
{
    [self clearCacheIfExpire:request];
    
    VZRequestMethod method = [request requestMethod];
    NSString *url = [request requestUrl];
    NSDictionary *param = [request requestParam];
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    switch (request.requestSerializerType) {
        case VZRequestSerializerTypeHTTP:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case VZRequestSerializerTypeJSON:
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
    }
    
    requestSerializer.timeoutInterval = [request requestTimeout];
    
    NSDictionary *headerFields = [request requestHeader];
    if (headerFields != nil) {
        for (id fieldKey in headerFields) {
            id fieldValue = headerFields[fieldKey];
            if ([fieldKey isKindOfClass:[NSString class]] && [fieldValue isKindOfClass:[NSString class]]) {
                [requestSerializer setValue:(NSString *)fieldValue forHTTPHeaderField:(NSString *)fieldKey];
            } else {
                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    _manager.requestSerializer = requestSerializer;
    
    if (request.requestIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    switch (method) {
        case VZRequestMethodGET:
            [self handleGetRequest:request withUrl:url withParam:param];
            break;
        case VZRequestMethodPOST:
            [self handlePostRequest:request withUrl:url withParam:param];
            break;
        case VZRequestMethodPOSTWithFile:
            [self handlePostWithFileRequest:request withUrl:url withParam:param];
            break;
    }
}

#pragma mark - Private
- (void)handleGetRequest:(__kindof VZBaseRequest *)request withUrl:(NSString *)url withParam:(NSDictionary *)param{
    if (request.cacheInterval > 0) {
        NSString *urlKey = [url stringByAppendingString:[self serializeParams:param]];
        id cachedReponseObject = [_cache objectForKey:urlKey];
        if (cachedReponseObject) {
            request.isResponseFromCache = YES;
            [self handleCacheResponse:cachedReponseObject withRequest:request];
            
            return;
        }
    } 
    
    [_manager GET:url
       parameters:param
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              
              [self handleSuccess:task withResponse:responseObject withRequest:request];
          }
          failure: ^(NSURLSessionDataTask *task, NSError *error) {
              [self handleFailure:task withError:error withRequest:request];
          }];
}

- (void)handlePostRequest:(__kindof VZBaseRequest *)request withUrl:(NSString *)url withParam:(NSDictionary *)param{
    [_manager POST:url
        parameters:param
           success: ^(NSURLSessionDataTask *task, id responseObject) {
               [self handleSuccess:task withResponse:responseObject withRequest:request];
           }
           failure: ^(NSURLSessionDataTask *task, NSError *error) {
               [self handleFailure:task withError:error withRequest:request];
           }];
}

- (void)handlePostWithFileRequest:(__kindof VZBaseRequest *)request withUrl:(NSString *)url withParam:(NSDictionary *)param{
    _uploadTask =[_manager POST:url
                     parameters:param
      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          NSDictionary *uploadDict = [request uploadDataDict];
          if (uploadDict) {
              [formData appendPartWithFileData:uploadDict[@"fileData"]
                                          name:uploadDict[@"name"]
                                      fileName:uploadDict[@"fileName"]
                                      mimeType:uploadDict[@"mimeType"]];
          }
      }
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           if (request.uploadProgressBlock) {
                               request.uploadProgressBlock(uploadProgress.fractionCompleted);
                           }
                       }
                        success: ^(NSURLSessionDataTask *task, id responseObject) {
                            [self handleSuccess:task withResponse:responseObject withRequest:request];
                        }
                        failure: ^(NSURLSessionDataTask *task, NSError *error) {
                            [self handleFailure:task withError:error withRequest:request];
                        }];
}

- (void)handleSuccess:(NSURLSessionDataTask *)task withResponse:(id)responseObject withRequest:(VZBaseRequest *)request{ 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    request.responseObject = responseObject;
    
    if(!responseObject) // server not response object; data report related server
    {
        if (request.completeBlock) {
            request.completeBlock(request);
            request.completeBlock = nil;
        }
        
        return;
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        request.responseDict = responseDic;
        
        if ([request isResponseOkWithDict:responseDic]) {
            request.retCodeOk = YES;
        }
        
        if (request.responseClass) {
            if (request.retCodeOk) {
                request.responseObject = [request.responseClass mj_objectWithKeyValues:responseDic];
                
                //cache object
                if ((!request.isResponseFromCache) && request.cacheInterval > 0) {
                    NSString *urlKey = [request.requestUrl stringByAppendingString:[self serializeParams:request.requestParam]];
                    [_cache setObject:responseObject forKey:urlKey];
                }
            }
        }
        
        if(!request.retCodeOk) {
            NSString *responseMsg = [request responseMsgWithDict:responseDic];
            if (responseMsg) {
                NSDictionary *userInfo = @{@"msg": responseMsg};
                NSError *domainError = [NSError errorWithDomain:@"VZ" code:-110 userInfo:userInfo];
                request.responseError = domainError;
                request.responseErrorInfoFromDomain = responseDic[@"retMsg"];
            }
        }
    }else {
        NSDictionary *userInfo = @{@"msg": @"server error"};
        NSError *domainError = [NSError errorWithDomain:@"VZ" code:-1 userInfo:userInfo];
        request.responseError = domainError;
        request.responseErrorInfoFromDomain = @"server error";
    }
    
    if (request.completeBlock) {
        request.completeBlock(request);
        request.completeBlock = nil;
    }
}

- (void)handleCacheResponse:(id)responseObject withRequest:(VZBaseRequest *)request{
    NSDictionary *responseDic = (NSDictionary *)responseObject;
    request.responseObject = [request.responseClass mj_objectWithKeyValues:responseDic];
    
    if (request.completeBlock) {
        request.completeBlock(request);
    }
}

- (void)handleFailure:(NSURLSessionDataTask *)task withError:(NSError *)error withRequest:(VZBaseRequest *)request{
    if (request.requestIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    request.responseError = error;
    if (request.completeBlock) {
        request.completeBlock(request);
        request.completeBlock = nil;
    }
}

- (void)clearCacheIfExpire:(VZBaseRequest *)request
{
    if (request.cacheInterval > 0) {
        double pastTimeInterval = [[NSDate date] timeIntervalSince1970] - request.cacheInterval;
        NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:pastTimeInterval];
        [self.cache trimToDate:pastDate];
    }
}

-(NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *encodedValue = [obj.description stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    return queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
}

@end
