#import "NSData+Base64.h"



@implementation NSData (Base64)


-(NSData*)base64Encode
{
    return [self base64EncodedDataWithOptions: NSDataBase64Encoding64CharacterLineLength];
}


-(NSData*)base64Decode
{
    return [[NSData alloc] initWithBase64EncodedData:self options: NSDataBase64DecodingIgnoreUnknownCharacters];
}


@end
