#import "RSACryptor.h"
#import <Security/Security.h>

// RSA Encrypt
// http://stackoverflow.com/questions/4211484/send-rsa-public-key-to-iphone-and-use-it-to-encrypt


// RSA Decrypt
// http://stackoverflow.com/questions/10579985/how-can-i-get-seckeyref-from-der-pem-file
// http://stackoverflow.com/questions/23615932/x-509-rsa-encryption-decryption-ios


// Get Exponent and Modulus
// http://stackoverflow.com/questions/3116907/rsa-get-exponent-and-modulus-given-a-public-key


@implementation RSACryptor {
    SecKeyRef publicKey;
    SecKeyRef privateKey;
}

+ (instancetype)sharedInstance {
    static RSACryptor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)dealloc {
    CFRelease(publicKey);
    CFRelease(privateKey);
    publicKey = NULL;
    privateKey = NULL;
}

-(SecKeyRef) publicKey {
    return publicKey;
}

-(SecKeyRef) privateKey {
    return privateKey;
}

-(void) setPublicKey:(SecKeyRef)keyRef {
    if (publicKey) CFRelease(publicKey);
    publicKey = keyRef;
}

-(void) setPrivateKey:(SecKeyRef)keyRef {
    if (privateKey) CFRelease(privateKey);
    privateKey = keyRef;
}

-(void) loadPublicKeyFromFile: (NSString*) derFilePath {
    NSData *derData = [[NSData alloc] initWithContentsOfFile:derFilePath];
    [self loadPublicKeyFromData: derData];
}

-(void) loadPrivateKeyFromP12File: (NSString*) p12FilePath password:(NSString*)p12Password {
    NSData *p12Data = [NSData dataWithContentsOfFile:p12FilePath];
    [self loadPrivateKeyFromP12Data: p12Data password:p12Password];
}

-(void) loadPublicKeyFromData: (NSData*) derData {
    [self setPublicKey:[self getPublicKeyRefrenceFromeData: derData]];
}

-(void) loadPrivateKeyFromP12Data: (NSData*) p12Data password:(NSString*)p12Password {
    [self setPrivateKey:[self getPrivateKeyRefrenceFromData: p12Data password: p12Password]];
}

-(SecKeyRef) getPublicKeyRefrenceFromeData: (NSData*)derData {
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust;
    OSStatus status = SecTrustCreateWithCertificates(certificate, policy, &trust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(trust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(trust);
    CFRelease(certificate);
    CFRelease(policy);
    CFRelease(trust);
    
    return securityKey;
}

-(SecKeyRef) getPrivateKeyRefrenceFromData: (NSData*)p12Data password:(NSString*)password {
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}



#pragma mark - Public Key Encrypt And Private Key Decrypt

-(NSData*) publicKeyEncryptData:(NSData*)data {
    return [self publicKeyEncryptData: data key:self.publicKey];
}

// 加密的大小受限于SecKeyEncrypt函数，SecKeyEncrypt要求明文和密钥的长度一致，如果要加密更长的内容，需要把内容按密钥长度分成多份，然后多次调用SecKeyEncrypt来实现
-(NSData*) publicKeyEncryptData:(NSData*)data key:(SecKeyRef)keyRef {
    size_t cipherBufferSize = SecKeyGetBlockSize(keyRef);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;       // 分段加密, 加密数据长度 <= 模长-11, 明文长度(bytes) <= 密钥长度(bytes)-11
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i = 0; i < blockCount; i++) {
        NSUInteger bufferSize = MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    return encryptedData;
}

-(NSData*) privateKeyDecryptData:(NSData*)data {
    return [self privateKeyDecryptData:data key:self.privateKey];
}

-(NSData*) privateKeyDecryptData:(NSData*)data key:(SecKeyRef)keyRef {
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(keyRef) - 12;
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(keyRef, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
    
    if (status != noErr) {
        return nil;
    }
    
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    return decryptedData;
}


#pragma mark - Public Key Decrypt And Private Key Encrypt

-(NSData*) publicKeyDecryptData:(NSData*)data {
    return [self publicKeyDecryptData:data key:self.publicKey];
}

-(NSData*) publicKeyDecryptData:(NSData*)data key:(SecKeyRef)keyRef {
    return [[self class] decryptData:data withKeyRef:keyRef];
}

-(NSData*) privateKeyEncryptData:(NSData*)data {
    return [self privateKeyEncryptData:data key:self.privateKey];
}

-(NSData*) privateKeyEncryptData:(NSData*)data key:(SecKeyRef)keyRef {
    return [[self class] encryptData:data withKeyRef:keyRef];
}

// Reference: https://github.com/ideawu/Objective-C-RSA

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    return ret;
}

@end
