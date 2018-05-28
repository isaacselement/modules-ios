#import <Foundation/Foundation.h>

@interface NetworkInformation : NSObject


//+(NSString*) getEN0SubnetMask;
+(NSString*) getEN0MacAddress;


+(NSString*) getSSID;
+(NSString*) getBSSID;
+(NSString*) getIPAddress:(BOOL)preferIPv4;




#pragma mark - Traffic Statistics
/**
 device ifa_name:
 
lo0
lo0
lo0
lo0
gif0
stf0
en0
en0
en0
en1
en2
p2p0
awdl0
awdl0
bridge0
 
 **/

int getWWANTrafficBytes();

int getWIFITrafficBytes();

+(NSString*) bytesToAvaiUnit: (int)bytes;

@end
