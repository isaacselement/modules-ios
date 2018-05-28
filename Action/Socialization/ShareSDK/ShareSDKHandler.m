#import "ShareSDKHandler.h"


@implementation ShareSDKHandler


#pragma mark - Subclass Override

+ (void)initializePlatforms
{
    
}


#pragma mark - In AppDelegate Methods

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializePlatforms];
}

+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}


#pragma mark - Auth Methods

+ (void)authorizeWithType:(ShareType)shareType callback:(void(^)(SSAuthState state))callback
{
    [ShareSDK authWithType:shareType options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
        if (callback) {
            callback(state);
        }
    }];
}

+ (void)getUserInfoWithType:(ShareType)shareType callback:(void(^)(id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error))callback
{
    [ShareSDK getUserInfoWithType:shareType authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (callback) {
            callback(userInfo, error);
        }
    }];
}

+ (void)setCurrentAuthorizedUser:(id<ISSPlatformUser>)user type:(ShareType)type
{
    [ShareSDK setCurrentAuthUser:user type:type];
}


#pragma mark - Share Methods

+(void) share:(ShareType)type title:(NSString*)title content:(NSString*)content imageURL:(NSString*)imageURL link:(NSString*)link callback:(void(^)(SSResponseState state))callback
{
    id<ISSCAttachment> remoteAttachment = nil;
    if (imageURL) remoteAttachment = [ShareSDKCoreService attachmentWithUrl:imageURL];
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:content image:remoteAttachment title:title url:link description:content mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (callback) {
                            callback(state);
                        }
                    }];
}


@end
