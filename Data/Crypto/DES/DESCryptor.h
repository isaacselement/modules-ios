#import <Foundation/Foundation.h>

@interface DESCryptor : NSObject

+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key ;

+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key ;

@end
