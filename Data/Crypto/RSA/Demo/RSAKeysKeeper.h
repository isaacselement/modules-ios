#import <Foundation/Foundation.h>

@interface RSAKeysKeeper : NSObject


+(NSString*) derKey;  // public
+(NSString*) p12Key;  // private
+(NSString*) p12Password;

@end
