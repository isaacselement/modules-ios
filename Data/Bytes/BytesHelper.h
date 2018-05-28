#import <Foundation/Foundation.h>

@interface BytesHelper : NSObject


#pragma mark - Decimal

+(NSString*)stringToDecimalString:(NSString*)string;
+(NSString*)dataToDecimalString:(NSData*)data;
+(NSString*)bytesToDecimalString:(Byte *)bytes length:(NSUInteger)length;
+(void) printDataAsDecimal:(NSData*)data;


#pragma mark - Binary

+(NSString*)stringToBinaryString:(NSString *)string;
+(NSString*)dataToBinaryString:(NSData *)data;
+(NSString*)bytesToBinaryString:(Byte *)bytes length:(NSUInteger)length;
+(NSString*) bytesToBinaryString:(Byte)byte;

#pragma mark -  rotate

int leftRotate(int n, unsigned int d);
int rightRotate(int n, unsigned int d);

unsigned char rotateLeftByte(unsigned char byte, int d);
unsigned char rotateRightByte(unsigned char byte, int d);


@end
