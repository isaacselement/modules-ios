#import "WebViewProgressHandler.h"

NSString *__COMPLETE_URL_PATH__ = @"/testwebviewprogressproxy/complete";

const float __INITIALPROGRESSVALUE = 0.1f;
const float __INTERACTIVEPROGRESSVALUE = 0.5f;
const float __FINALPROGRESSVALUE = 0.9f;

@implementation WebViewProgressHandler
{
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    float _progress;
    BOOL _interactive;
}

- (id)init
{
    self = [super init];
    if (self) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress
{
    if (_progress < __INITIALPROGRESSVALUE) {
        [self setProgress:__INITIALPROGRESSVALUE];
    }
}

- (void)incrementProgress
{
    float progress = _progress;
    float maxProgress = _interactive ? __FINALPROGRESSVALUE : __INTERACTIVEPROGRESSVALUE;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if (self.progressUpdateCallback) {
            self.progressUpdateCallback(progress);
        }
    }
}

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL) caculateShouldCompleteAtRequest:(UIWebView*)webView request:(NSURLRequest *)request
{
    if ([request.URL.path isEqualToString:__COMPLETE_URL_PATH__]) {
        [self completeProgress];
        return YES;
    }
    return NO;
}

- (void) caculateShouldResetAtRequest:(UIWebView*)webView request:(NSURLRequest *)request delegateResult:(BOOL)result
{
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (result && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
}

- (void) caculateAtRequestStart:(UIWebView*)webView
{
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void) caculateAtRequestOver:(UIWebView*)webView
{
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, __COMPLETE_URL_PATH__];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}


@end
