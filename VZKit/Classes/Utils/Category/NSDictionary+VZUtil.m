//
//  NSDictionary+VZUtil.m
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import "NSDictionary+VZUtil.h"

@implementation NSDictionary (VZUtil)

+ (instancetype)dictionaryInURL:(NSString *)url
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    for(NSURLQueryItem *item in components.queryItems) {
        BOOL isValidateValue = item.name && item.value && ![item.name isEqualToString:@""] && ![item.value isEqualToString:@""];
        if (isValidateValue) {
            dict[item.name] = item.value;
        } else {
            return nil;
        }
    }
    return dict;
}
 
+ (instancetype)dictionaryFromJsonString:(NSString *)JSONString
{
    NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    return jsonDict;
}

@end
