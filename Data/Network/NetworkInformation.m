#import "NetworkInformation.h"

// ssid and bssid
#import <SystemConfiguration/CaptiveNetwork.h>

// mac address
// http://stackoverflow.com/questions/677530/how-can-i-programmatically-get-the-mac-address-of-an-iphone
#import "IPAddress.h"


// ip address
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_WIFI                @"en0"
#define IOS_CELLULAR            @"pdp_ip0"
#define IF_device_loopback      @"lo0"          // loopback device

#define IP_ADDR_IPv4            @"ipv4"
#define IP_ADDR_IPv6            @"ipv6"


@implementation NetworkInformation

/*
// http://stackoverflow.com/questions/2023592/iphone-wifi-subnet-mask-and-router-address
+(NSString*) getEN0SubnetMask
{
    struct ifaddrs *ifa = NULL, *ifList;
    getifaddrs(&ifList); // should check for errors
    for (ifa = ifList; ifa != NULL; ifa = ifa->ifa_next) {
        struct sockaddr	* address = ifa->ifa_addr; // interface address
        struct sockaddr	* subnetmask = ifa->ifa_netmask; // subnet mask
        struct sockaddr	* broadcastAddress = ifa->ifa_dstaddr; // broadcast address, NOT router address
    }
    freeifaddrs(ifList); // clean up after yourself
    return nil;
}
*/


+(NSString*) getEN0MacAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    for (int i = 0; i < MAXADDRS; i++)
    {
        static unsigned long localHost = 0x7F000001;        // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
//        NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
        
        //decided what adapter you want details for
        if (strncmp(if_names[i], "en0", 3) == 0)
        {
//            NSLog(@"Adapter en0 has a IP of %s", ip_names[i]);
            return [NSString stringWithCString:hw_addrs[i] encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}



+(NSString*) getSSID
{
    return [self getNetworkInfo: kCNNetworkInfoKeySSID];
}

+(NSString*) getBSSID
{
    return [self getNetworkInfo: kCNNetworkInfoKeyBSSID];
}

+(NSString*) getNetworkInfo: (CFStringRef)kCNNetworkInfoKey
{
    CFArrayRef array = CNCopySupportedInterfaces();
    if (array == nil) return nil;
    
    for (int i = 0; i < CFArrayGetCount(array); i++) {
        
        const void* key = CFArrayGetValueAtIndex(array, i);
        CFDictionaryRef dictionary = CNCopyCurrentNetworkInfo(key);
        if (dictionary == NULL) {
            return NULL;
        }
        CFStringRef string = CFDictionaryGetValue(dictionary, kCNNetworkInfoKey);
        NSString* resultString = [NSString stringWithString: (__bridge NSString*)string];
        CFRelease(dictionary);
        
        if (resultString.length != 0) {
            CFRelease(array);
            return resultString;
        }
    }
    CFRelease(array);
    return NULL;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}




#pragma mark - Traffic Statistics

int getWWANTrafficBytes()
{
    return getInterfaceTotalBytes("pdp_ip0");
}

int getWIFITrafficBytes()
{
    return getInterfaceTotalBytes("en0");
}

int getInterfaceTotalBytes(char* device)
{
    return getInterfaceSentReceiveBytes(device, NO) + getInterfaceSentReceiveBytes(device, YES);
}


int getInterfaceSentReceiveBytes(char* device, bool receive)
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    
    uint32_t bytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        
//        printf("ifa_name: %s \n", ifa->ifa_name);
        
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        // get the specified deveice sent/received traffic flow bytes
        if (!strncmp(ifa->ifa_name, device, strlen(device))) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            bytes += (receive ? if_data->ifi_ibytes : if_data->ifi_obytes);
            
//            printf("%s - %s :iBytes is %d, oBytes is %d \n", receive ? "Receive":"Sent", ifa->ifa_name, bytes, bytes);
        }
    }
    freeifaddrs(ifa_list);
    
    return bytes;
}



+(NSString*) bytesToAvaiUnit: (int)bytes
{
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

@end
