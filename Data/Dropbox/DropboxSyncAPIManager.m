#import "DropboxSyncAPIManager.h"
#import <Dropbox/Dropbox.h>

@implementation DropboxSyncAPIManager


static DBFilesystem *filesystem = nil;


#pragma mark - init account methods (needed)

/**
    1 .    put it in AppDelegate - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 */
+(void)setAppKey:(NSString *)key secret:(NSString *)secret
{
    DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:key secret:secret];
    [DBAccountManager setSharedManager:accountManager];
}

/**
   2 .     once you set appKey & appSecret , then call this method to authorize (you can put it anywhere)
 */
+(void) authorize: (UIViewController *)viewContrller {
    [[DBAccountManager sharedManager] linkFromController: viewContrller];
}

/**
   3 . put it in AppDelegate - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    @return the current authorize account
 */
+(DBAccount*) authorizeURLCallback: (NSURL*)url {
    return [[DBAccountManager sharedManager] handleOpenURL:url];
}

#pragma mark - getter methods

+(DBAccount*) getLinkedAccount {
    return [[DBAccountManager sharedManager] linkedAccount] ;
}

+(NSArray*) getLinkedAccounts {
    return [[DBAccountManager sharedManager] linkedAccounts] ;
}

+(DBPath*) getRootPath {
    return [DBPath root];
}

+(DBFilesystem*) getFilesystem {
    DBAccount* account = [DropboxSyncAPIManager getLinkedAccount];
    if (! filesystem) {
        filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem: filesystem];
    }
    return filesystem;
//    return [DBFilesystem sharedFilesystem]; 
//    return [[DBFilesystem alloc] initWithAccount:account];    // Can not upload !!!
}


@end
