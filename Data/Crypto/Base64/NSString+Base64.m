#import "NSString+Base64.h"

@implementation NSString (Base64)

-(NSString*) base64Encode
{
    NSData *plainTextData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64EncodeString = [plainTextData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncodeString;
}

-(NSString*) base64Decode
{
    NSData* base64EncodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData* base64DecodeData = [[NSData alloc] initWithBase64EncodedData: base64EncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString* base64DecodeString = [[NSString alloc] initWithData: base64DecodeData encoding:NSUTF8StringEncoding];
    return base64DecodeString;
}

@end

