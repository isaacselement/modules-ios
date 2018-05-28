#import "RSABase64Cryptor.h"
#import "RSAKeysKeeper.h"


int rsa_main(int argc, char *argv[])
{
    @autoreleasepool {
        
        RSABase64Cryptor* rsaEncryptor = [[RSABase64Cryptor alloc] init];
        
        // not recommended, the key files will package to you app
//        NSString* publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
//        NSString* privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
//        [rsaEncryptor loadPublicKeyFromFile: publicKeyPath];
//        [rsaEncryptor loadPrivateKeyFromFile: privateKeyPath password:p12Password];
        
        [rsaEncryptor loadPublicKeyFromString: RSAKeysKeeper.derKey];
        [rsaEncryptor loadPrivateKeyFromString: RSAKeysKeeper.p12Key password:RSAKeysKeeper.p12Password];
        
        NSString* publicEncryptBASE64STRING = [rsaEncryptor publicKeyBase64EncryptString:@"I.O.S"];
        NSLog(@"Encrypted: %@", publicEncryptBASE64STRING);
        NSString* privateDecryptString = [rsaEncryptor privateKeyBase64DecryptString: publicEncryptBASE64STRING];
        NSLog(@"Decrypted: %@", privateDecryptString);
        
        NSString* privateEncryptBASE64STRING = [rsaEncryptor privateKeyBase64EncryptString:@"I.O.S"];
        NSLog(@"- Encrypted: %@", privateEncryptBASE64STRING);
        NSString* publicDecryptString = [rsaEncryptor publicKeyBase64DecryptString: privateEncryptBASE64STRING];
        NSLog(@"- Decrypted: %@", publicDecryptString);
        
        
        // System.out.println the encrypt string from JAVA Below, and paste it here.
        NSString* rsaEncrypyBase64FromJava = [NSString stringWithFormat:@"%@\r%@\r%@",
                                              @"ZNKCVpFYd4Oi2pecLhDXHh+8kWltUMLdBIBDeTvU5kWpTQ8cA1Y+7wKO3d/M8bhULYf1FhWt80Cg",
                                              @"7e73SV5r+wSlgGWBvTIxqgTWFS4ELGzsEJpVVSlK1oXF0N2mugOURUILjeQrwn1QTcVdXXTMQ0wj",
                                              @"50GNwnHbAwyLvsY5EUY="];
        NSString* resultString = [rsaEncryptor privateKeyBase64DecryptString: rsaEncrypyBase64FromJava];
        NSLog(@"Decrypt Java RSA String: %@", resultString);
        
        return 1;
    }
}






