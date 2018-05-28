#import "UUIDOwner.h"
#import "SSKeychain.h"

#import "_Bytes.h"
#import "NSData+Base64.h"


#define Base64Encode(_data) [_data base64Encode]
#define Base64Decode(_data) [_data base64Decode]

#define mdBYTES(_bytes, _length)    [NSData dataWithBytes: _bytes length:_length]
#define mdString(_string)           [_string dataUsingEncoding: NSUTF8StringEncoding]
#define msDATA(_data)               [[NSString alloc] initWithData: _data encoding:NSUTF8StringEncoding]


#define mDecode(_data) [self decode: _data]
#define mEncode(_data) [self encode: _data]


#define IsStringEmpty(_s) !_s || [_s isEqualToString:@""]


@implementation UUIDOwner

+(NSString*) UUIDForDevice
{
    NSString* plistKey = @"mUUID";
    NSString* keyChainKey = @"mUDID";
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString* uuid = [[NSUserDefaults standardUserDefaults] objectForKey:plistKey];
    if (IsStringEmpty(uuid)) {
        NSString* uuidEncode = [SSKeychain passwordForService:keyChainKey account: bundleIdentifier];
        
        if (IsStringEmpty(uuidEncode)) {
            CFUUIDRef cfuuid = CFUUIDCreate(NULL);
            uuid = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, cfuuid));
            
            uuidEncode = msDATA(Base64Encode(mEncode(mdString(uuid))));
            [SSKeychain setPassword:uuidEncode forService:keyChainKey account: bundleIdentifier];
        } else {
            uuid =  msDATA(mDecode(Base64Decode(mdString(uuidEncode))));
        }
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:plistKey];
    }
    
    // Test to clear
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:plistKey];
//    [SSKeychain deletePasswordForService: keyChainKey account: bundleIdentifier];
    
    return uuid;
}



#pragma mark - Encode

static int shift = 5;
static int eraseVal = 0x41;

+(NSData*) encode: (NSData*)data
{
    int length = (int)data.length;
    Byte* encodeBytes = [self encode: [data bytes] length:length];
    NSData* encodeData = [NSData dataWithBytes: encodeBytes length:length];
    free(encodeBytes);
    return encodeData;
}

// need free outside
+(Byte*) encode: (const Byte*)bytes length:(int)length
{
    Byte* encodeBytes = malloc(sizeof(Byte) * length);
    for (int i = 0; i < length; i++) {
        Byte tmp;
        if (i == length - 1) {
            tmp = bytes[i] ^ encodeBytes[0];
        } else {
            tmp = bytes[i] ^ bytes[i+1];
        }
        encodeBytes[i] = rotateLeftByte(tmp ^ eraseVal, shift);
    }
    return encodeBytes;
}

#pragma mark - Decode

+(NSData*) decode: (NSData*)data
{
    int length = (int)data.length;
    Byte* decodeBytes = [self decode: [data bytes] length:length];
    NSData* decodeData = [NSData dataWithBytes:decodeBytes length:length];
    free(decodeBytes);
    return decodeData;
}

// need free outside
+(Byte*) decode: (const Byte*)bytes length:(int)length
{
    Byte* decodeBytes = malloc(sizeof(Byte) * length);
    for (int i = length - 1; i >= 0; i--) {
        Byte tmp = rotateRightByte(bytes[i], shift);
        if (i == length - 1) {
            tmp = tmp ^ bytes[0];
        } else {
            tmp = tmp ^ decodeBytes[i+1];
        }
        decodeBytes[i] = tmp ^ eraseVal;
    }
    return decodeBytes;
}

@end
