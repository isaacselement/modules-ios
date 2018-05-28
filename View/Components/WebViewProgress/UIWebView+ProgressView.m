#import "UIWebView+ProgressView.h"
#import "UIWebView+HookDelegateMethods.h"
#import "WebViewProgressView.h"
#import "WebViewProgressHandler.h"
#import <objc/runtime.h>

@implementation UIWebView (HookDelegateMethods)


-(BOOL) delegateShouldStartWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return ![[self getWebViewProgressViewHandler] caculateShouldCompleteAtRequest:self request:request];
}

-(void) delegateStartedWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType result:(BOOL)result
{
    [[self getWebViewProgressViewHandler] caculateShouldResetAtRequest:self request:request delegateResult:result];
}

-(void) delegateDidStartLoad
{
    [[self getWebViewProgressViewHandler] caculateAtRequestStart:self];
}

-(void) delegateDidFinishLoad
{
    [[self getWebViewProgressViewHandler] caculateAtRequestOver:self];
}

-(void) delegateDidFailLoadWithError:(nullable NSError *)error
{
    [[self getWebViewProgressViewHandler] caculateAtRequestOver:self];
}

int __WEBVIEWPROGRESSVIEW_TAG = 2008 ;
const void* __PROGRESSHANDLER_KEY = "_web_view_progress_handler";
-(WebViewProgressHandler*) getWebViewProgressViewHandler
{
    WebViewProgressView* view = (WebViewProgressView*)[self viewWithTag: __WEBVIEWPROGRESSVIEW_TAG];
    if (!view) {
        // create progress view
        CGRect frame = CGRectMake(0, -self.scrollView.contentOffset.y, self.bounds.size.width, 2.0f);
        view = [[WebViewProgressView alloc] initWithFrame:frame];
        view.tag = __WEBVIEWPROGRESSVIEW_TAG;
        [self addSubview:view];
        
        // create progress handler
        WebViewProgressHandler* handler = [[WebViewProgressHandler alloc] init];
        handler.progressUpdateCallback = ^(float progress) {
            [view setProgress: progress];
        };
        objc_setAssociatedObject(self, __PROGRESSHANDLER_KEY, handler, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objc_getAssociatedObject(self, __PROGRESSHANDLER_KEY);
}

@end
