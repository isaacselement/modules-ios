#import "FacebookHandler.h"
#import <objc/runtime.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface FBSDKShareDialog()

@property (copy) FBHandlerCallbackCompleted completedCallback;
@property (copy) FBHandlerCallbackFailed failedCallback;
@property (copy) FBHandlerCallbackCanceled canceledCallback;

@end

@interface FBSDKShareDialog(FBSDKSharingDelegate)

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results;
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error;
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer;

@end


@implementation FBSDKShareDialog(FBSDKSharingDelegate)

const char* __fbCompletedCallback__ = "fbCompletedCallback";
const char* __fbFailedCallback__ = "fbFailedCallback";
const char* __fbCanceledCallback__ = "fbCanceledCallback";

-(void)setCompletedCallback:(FBHandlerCallbackCompleted)completedCallback
{
    objc_setAssociatedObject(self, __fbCompletedCallback__, completedCallback, OBJC_ASSOCIATION_COPY);
}

-(FBHandlerCallbackCompleted)completedCallback
{
    return objc_getAssociatedObject(self, __fbCompletedCallback__);
}

-(void)setFailedCallback:(FBHandlerCallbackFailed)failedCallback
{
    objc_setAssociatedObject(self, __fbFailedCallback__, failedCallback, OBJC_ASSOCIATION_COPY);
}

-(FBHandlerCallbackFailed)failedCallback
{
    return objc_getAssociatedObject(self, __fbFailedCallback__);
}

-(void)setCanceledCallback:(FBHandlerCallbackCanceled)canceledCallback
{
    objc_setAssociatedObject(self, __fbCanceledCallback__, canceledCallback, OBJC_ASSOCIATION_COPY);
}

-(FBHandlerCallbackCanceled)canceledCallback
{
    return objc_getAssociatedObject(self, __fbCanceledCallback__);
}


#pragma mark - FBSDKSharingDelegate Methods

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    if (self.completedCallback) self.completedCallback(self, results);
    self.completedCallback = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    if (self.failedCallback) self.failedCallback(self, error);
    self.failedCallback = nil;
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    if (self.canceledCallback) self.canceledCallback(self);
    self.canceledCallback = nil;
}


@end




@implementation FacebookHandler


#pragma mark - Public Methods

+(void) shareLink:(NSString*)link title:(NSString*)title content:(NSString*)content imageURL:(NSString*)imageURL :(FBHandlerCallbackCompleted)completedCallback :(FBHandlerCallbackFailed)failedCallback :(FBHandlerCallbackCanceled)canceledCallback
{
    FBSDKShareLinkContent* linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentTitle = title;
    linkContent.contentDescription = content;
    linkContent.contentURL = [NSURL URLWithString:link];
    linkContent.imageURL = [NSURL URLWithString:imageURL];
    
    FBSDKShareDialog *shareDialog = [self getFBSDKShareDialog:completedCallback :failedCallback :canceledCallback];
    shareDialog.shareContent = linkContent;
//    NSError* error = nil;
//    BOOL validation = [shareDialog validateWithError:&error];
    [shareDialog show];
}



#pragma mark - Private Methods

+(FBSDKShareDialog*) getFBSDKShareDialog:(FBHandlerCallbackCompleted)completedCallback :(FBHandlerCallbackFailed)failedCallback :(FBHandlerCallbackCanceled)canceledCallback
{
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    shareDialog.completedCallback = completedCallback;
    shareDialog.failedCallback = failedCallback;
    shareDialog.canceledCallback = canceledCallback;
    shareDialog.fromViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    shareDialog.delegate = (id<FBSDKSharingDelegate>)shareDialog;
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        shareDialog.mode = FBSDKShareDialogModeFeedWeb;
    }
    return shareDialog;
}


@end
