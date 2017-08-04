//
//  NSString+VZUtil.m
//  VZKit
//
//  Created by VonZen on 2017/8/4.
//

#import "NSString+VZUtil.h"
#import "NSData+VZUtil.h"

@implementation NSString (VZUtil)

// Checking if String is Empty
-(BOOL)isBlank
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}
//Checking if String is empty or nil
-(BOOL)isValid
{
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

//Checking if String' length match min length
-(BOOL)isValidWithLength:(NSInteger)length
{
    if (![self isValid]) {
        return NO;
    }
    
    return [self removeWhiteSpacesFromString].length >= length;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeAllWhiteSpacesFromString
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

// If string contains substring
- (BOOL)contain:(NSString *)string
{
    return ([self rangeOfString:string].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string
- (BOOL)isBeginWith:(NSString *)string
{
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndWith:(NSString *)string
{
    return ([self hasSuffix:string]) ? YES : NO;
}

// Replace particular characters in my string with new character
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string
{
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString])
    {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}


// If my string contains ony letters
- (BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// Convert array to string
+ (NSString *)getStringFromArray:(NSArray *)array withSeparator:(NSString *)separator
{
    return [array componentsJoinedByString:separator];
}

// Separate String to array
- (NSArray *)getArrayBy:(NSString *)separator
{
    return [self componentsSeparatedByString:separator];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}


// Convert string to NSData
- (NSData *)convertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// Is Valid Email
- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailPredicate evaluateWithObject:self];
}

// Is Valid Phone
- (BOOL)isValidPhoneNumber
{
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberPre evaluateWithObject:self];
}

// Is Valid URL
- (BOOL)isValidUrl
{
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlPre evaluateWithObject:self];
}

- (NSString *)aesEncrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    NSData *result = [data aesEncrypt:key];
    
    if (result && result.length > 0) {
        Byte *datas = (Byte*)result.bytes;
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

- (NSString *)aesDecrypt:(NSString *)key
{
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < self.length / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    NSData* result = [data aesDecrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end
