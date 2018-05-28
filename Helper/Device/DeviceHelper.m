#import "DeviceHelper.h"

#import <UIKit/UIKit.h>
#import <sys/stat.h>

#import <dlfcn.h>
#import <mach-o/dyld.h>



@implementation DeviceHelper


// http://blog.csdn.net/yiyaaixuexi/article/details/20286929
// http://theiphonewiki.com/wiki/Bypassing_Jailbreak_Detection

+(BOOL)isJailbroken
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/stash"]){
        return YES;
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        return YES;
    }
    
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        return YES;
    }

    if (0 == access("/private/var/stash", 0)) {
        return YES;
    }
    
    FILE* file = NULL;
    if ((file = fopen("/User/Applications", "r"))) {
        return YES;
    }
    
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        return YES;
    }
    
    
    
    return NO;
}


-(void) checkInject
{
    NSString* dylib = [[NSString alloc] initWithUTF8String:libsystem_kernel_dylib_path_name()];
    if ([dylib rangeOfString:@"iPhoneSimulator"].location != NSNotFound || [dylib rangeOfString:@"Xcode"].location != NSNotFound) {
        // in simulator
    }
    if ([dylib isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]) {
        // attacker not inject the 'libsystem_kernel.dylib'
    } else {
        // do whatever as the attacker want on this os/device ...
    }
}

const char* libsystem_kernel_dylib_path_name()
{
    int ret ;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        return dylib_info.dli_fname;
    }
    return "";
}



void checkDylibs(void)
{
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0 ; i < count; ++i) {
        NSString *name = [[NSString alloc]initWithUTF8String:_dyld_get_image_name(i)];
        NSLog(@"%@", name);
    }
}
void printEnv(void)
{
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
}

@end
