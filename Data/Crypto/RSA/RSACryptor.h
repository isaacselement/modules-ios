#import <Foundation/Foundation.h>

@interface RSACryptor : NSObject

+(RSACryptor*) sharedInstance;


#pragma mark - Initialize Keys Methods

-(void) loadPublicKeyFromFile: (NSString*) derFilePath;
-(void) loadPrivateKeyFromP12File: (NSString*) p12FilePath password:(NSString*)p12Password;

-(void) loadPublicKeyFromData: (NSData*) derData;
-(void) loadPrivateKeyFromP12Data: (NSData*) p12Data password:(NSString*)p12Password;

-(SecKeyRef) getPublicKeyRefrenceFromeData: (NSData*)derData ;
-(SecKeyRef) getPrivateKeyRefrenceFromData: (NSData*)p12Data password:(NSString*)password ;

-(SecKeyRef) publicKey;
-(SecKeyRef) privateKey;

-(void) setPublicKey:(SecKeyRef)key;
-(void) setPrivateKey:(SecKeyRef)key;


#pragma mark - Public Key Encrypt And Private Key Decrypt

-(NSData*) publicKeyEncryptData:(NSData*)data;
-(NSData*) publicKeyEncryptData:(NSData*)data key:(SecKeyRef)key;

-(NSData*) privateKeyDecryptData:(NSData*)data;
-(NSData*) privateKeyDecryptData:(NSData*)data key:(SecKeyRef)key;

#pragma mark - Public Key Decrypt And Private Key Encrypt

-(NSData*) publicKeyDecryptData:(NSData*)data;
-(NSData*) publicKeyDecryptData:(NSData*)data key:(SecKeyRef)keyRef;
-(NSData*) privateKeyEncryptData:(NSData*)data;
-(NSData*) privateKeyEncryptData:(NSData*)data key:(SecKeyRef)keyRef;

@end
