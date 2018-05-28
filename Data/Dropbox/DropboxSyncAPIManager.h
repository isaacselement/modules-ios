#import <UIKit/UIKit.h>

@class DBPath;
@class DBAccount;
@class DBFilesystem;

/** @description https://www.dropbox.com/developers/sync */

@interface DropboxSyncAPIManager : NSObject

+(void)setAppKey:(NSString *)key secret:(NSString *)secret;
+(void) authorize: (UIViewController *)viewContrller ;
+(DBAccount*) authorizeURLCallback: (NSURL*)url ;

/** @return current linked DBAccount  */
+(DBAccount*) getLinkedAccount ;

/** @return array with DBAccount , all linked account */
+(NSArray*) getLinkedAccounts ;

/** @return app's root path in dropbox sanbox */
+(DBPath*) getRootPath ;

/** @return current linked DBAccount's DBFilesystem, singleton */
+(DBFilesystem*) getFilesystem ;


@end
