#import <Foundation/Foundation.h>


// Download Facebook SDK , reference into project and do some setting according to Facebook Developer Website said.



@class FBSDKShareDialog;

typedef void(^FBHandlerCallbackCompleted)(FBSDKShareDialog* dialog, NSDictionary* results);
typedef void(^FBHandlerCallbackFailed)(FBSDKShareDialog* dialog, NSError* error);
typedef void(^FBHandlerCallbackCanceled)(FBSDKShareDialog* dialog);




@interface FacebookHandler : NSObject


+(void) shareLink:(NSString*)link title:(NSString*)title content:(NSString*)content imageURL:(NSString*)imageURL :(FBHandlerCallbackCompleted)completedCallback :(FBHandlerCallbackFailed)failedCallback :(FBHandlerCallbackCanceled)canceledCallback;


@end
