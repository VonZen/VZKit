//
//  NSString+VZUtil.h
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import <Foundation/Foundation.h>

@interface NSString (VZUtil)

-(BOOL)isBlank;
-(BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;

- (NSString *)removeAllWhiteSpacesFromString;

-(BOOL)isValidWithLength:(NSInteger)length;

- (BOOL)contain:(NSString *)string;
- (BOOL)isBeginWith:(NSString *)string;
- (BOOL)isEndWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;

+ (NSString *)getStringFromArray:(NSArray *)array withSeparator:(NSString *)separator;
- (NSArray *)getArrayBy:(NSString *)separator;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidUrl;

- (NSString *)aesEncrypt:(NSString *)key; 
- (NSString *)aesDecrypt:(NSString *)key;

@end
