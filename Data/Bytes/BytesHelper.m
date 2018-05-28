#import "BytesHelper.h"

@implementation BytesHelper


#pragma mark - Decimal

+(NSString*)stringToDecimalString:(NSString*)string
{
    return [self dataToDecimalString: [string dataUsingEncoding: NSUTF8StringEncoding]];
}

+(NSString*)dataToDecimalString:(NSData*)data
{
    return [self bytesToDecimalString:(Byte *)[data bytes] length:data.length];
}

+(NSString*)bytesToDecimalString:(Byte *)bytes length:(NSUInteger)length
{
    char* chars = malloc(length*8+1); chars[length*8] = '\0';   // c string end with '\0'
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++) {
        signed char byte = bytes[i];
        sprintf(&chars[i*8], "%d", byte);
        
        char* c = &chars[i*8];
        NSString *cstring = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
        [array addObject: cstring];
    }
//    printf("%s \n", &chars[2*8]);
    free(chars);
    NSString* string = [array componentsJoinedByString:@","];
    return string;
}

+(void) printDataAsDecimal:(NSData*)data
{
    Byte *byte = (Byte *)[data bytes];
    for (int i=0 ; i<[data length]; i++) {
        NSLog(@"%d",byte[i]);
    }
}


#pragma mark - Binary

+(NSString*)stringToBinaryString:(NSString *)string
{
    return [self dataToBinaryString: [string dataUsingEncoding:NSUTF8StringEncoding]];
}

+(NSString*)dataToBinaryString:(NSData *)data
{
    return [self bytesToBinaryString: (Byte*)[data bytes] length:data.length];
}

+(NSString*)bytesToBinaryString:(Byte *)bytes length:(NSUInteger)length
{
    char* chars = malloc(length*8+1); chars[length*8] = '\0';   // c string end with '\0'
    
    for(NSUInteger i = 0; i < length; i++) {
        for(int j = 0; j < 8; j++) {
            chars[i*8+(7-j)] = ((bytes[i]>>j)&0x01) == 1 ? '1' : '0';
        }
    }
//    printf("%s \n", chars);
    NSString *string = [NSString stringWithCString:chars encoding:NSUTF8StringEncoding];
    free(chars);
    return string;
}

+(NSString*) bytesToBinaryString:(Byte)byte
{
    char* c = malloc(sizeof(Byte) * 8 + 1); c[8] = '\0';
    for(int j = 0; j < 8; j++) {
        c[7-j] = ((byte>>j)&0x01) == 1 ? '1' : '0';
    }
    NSString *string = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
    free(c);
    return string;
}



#pragma mark -  rotate

// http://www.geeksforgeeks.org/fundamentals-of-algorithms/

#define INT_BITS 32

/*Function to left rotate n by d bits*/
int leftRotate(int n, unsigned int d)
{
    /* In n<<d, last d bits are 0. To put first 3 bits of n at
     last, do bitwise or of n<<d with n >>(INT_BITS - d) */
    return (n << d)|(n >> (INT_BITS - d));
}

/*Function to right rotate n by d bits*/
int rightRotate(int n, unsigned int d)
{
    /* In n>>d, first d bits are 0. To put last 3 bits of at
     first, do bitwise or of n>>d with n <<(INT_BITS - d) */
    return (n >> d)|(n << (INT_BITS - d));
}


#define BYTE_BITS 8

unsigned char rotateLeftByte(unsigned char byte, int d)
{
    return (byte << d | byte >> (BYTE_BITS - d));
}

unsigned char rotateRightByte(unsigned char byte, int d)
{
    return (byte >> d | byte << (BYTE_BITS - d));
}


@end
