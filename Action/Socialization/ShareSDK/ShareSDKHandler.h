#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface ShareSDKHandler : NSObject


#pragma mark - Subclass Override

+ (void)initializePlatforms;



#pragma mark - In AppDelegate Methods

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


#pragma mark - Auth Methods

+ (void)authorizeWithType:(ShareType)shareType callback:(void(^)(SSAuthState state))callback;

+ (void)getUserInfoWithType:(ShareType)shareType callback:(void(^)(id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error))callback
;

+ (void)setCurrentAuthorizedUser:(id<ISSPlatformUser>)user type:(ShareType)type;

#pragma mark - Share Methods

+(void) share:(ShareType)type title:(NSString*)title content:(NSString*)content imageURL:(NSString*)imageURL link:(NSString*)link callback:(void(^)(SSResponseState state))callback;

@end
