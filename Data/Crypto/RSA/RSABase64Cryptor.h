#import "RSACryptor.h"

@interface RSABase64Cryptor : RSACryptor



-(void) loadPublicKeyFromString: (NSString*)derBase64String;
-(void) loadPrivateKeyFromString: (NSString*)p12Base64String password:(NSString*)p12Password;



-(NSString*) publicKeyBase64EncryptString:(NSString*)string;
-(NSString*) privateKeyBase64DecryptString:(NSString*)base64EncodedString;

-(NSString*) privateKeyBase64EncryptString:(NSString*)string;
-(NSString*) publicKeyBase64DecryptString:(NSString*)base64EncodedString;

@end
