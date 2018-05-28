#import <UIKit/UIKit.h>

@interface WebViewProgressHandler : NSObject


@property (copy) void(^progressUpdateCallback)(float progress);


- (BOOL) caculateShouldCompleteAtRequest:(UIWebView*)webView request:(NSURLRequest *)request;

- (void) caculateShouldResetAtRequest:(UIWebView*)webView request:(NSURLRequest *)request delegateResult:(BOOL)result;

- (void) caculateAtRequestStart:(UIWebView*)webView;

- (void) caculateAtRequestOver:(UIWebView*)webView;


@end
