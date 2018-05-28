#import <UIKit/UIKit.h>

@interface UIWebView (HookDelegateMethods)

// make a new category to implement flowing methods, i.e. UIWebView+ProgressView is the default implementation


// return NO, will cancel externd delegate's "webView:shouldStartLoadWithRequest:navigationType" and next method "delegateStartedWithRequest:navigationType:result" call
-(BOOL) delegateShouldStartWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

-(void) delegateStartedWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType result:(BOOL)result;

-(void) delegateDidStartLoad;

-(void) delegateDidFinishLoad;

-(void) delegateDidFailLoadWithError:(nullable NSError *)error;


@end
