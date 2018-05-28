#import "RSABase64Cryptor.h"


@implementation RSABase64Cryptor


-(void) loadPublicKeyFromString: (NSString*)derBase64String
{
    [self loadPublicKeyFromData: [[NSData alloc] initWithBase64EncodedString:derBase64String options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

-(void) loadPrivateKeyFromString: (NSString*)p12Base64String password:(NSString*)p12Password
{
    [self loadPrivateKeyFromP12Data: [[NSData alloc] initWithBase64EncodedString:p12Base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] password:p12Password];
}

-(NSString*) publicKeyBase64EncryptString:(NSString*)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [self publicKeyEncryptData: data];
    NSString* base64EncryptedString = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncryptedString;
}

-(NSString*) privateKeyBase64DecryptString:(NSString*)base64EncodedString {
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* decryptData = [self privateKeyDecryptData: data];
    NSString* result = [[NSString alloc] initWithData: decryptData encoding:NSUTF8StringEncoding];
    return result;
}

-(NSString*) privateKeyBase64EncryptString:(NSString*)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [self privateKeyEncryptData: data];
    NSString* base64EncryptedString = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncryptedString;
}

-(NSString*) publicKeyBase64DecryptString:(NSString*)base64EncodedString {
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64EncodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* decryptData = [self publicKeyDecryptData: data];
    NSString* result = [[NSString alloc] initWithData: decryptData encoding:NSUTF8StringEncoding];
    return result;
}

@end
