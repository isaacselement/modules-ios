#import "UIWebView+HookDelegateMethods.h"
#import <objc/runtime.h>

@interface UIWebView () <UIWebViewDelegate>

@end

#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIWebView (HookDelegateMethods)

static const void* key_delegate = "delegate";

+(void)load {
    Method oldMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method newMethod = class_getInstanceMethod([self class], @selector(__Hook_setDelegate:));
    method_exchangeImplementations(oldMethod, newMethod);
    
    // another way
    /*
    IMP implement = method_getImplementation(oldMethod);
    void(*function)(id, SEL, id) = (__typeof(function))implement;
    method_setImplementation(oldMethod, imp_implementationWithBlock(^(id target, id delegate) {
        objc_setAssociatedObject(target, key_delegate, delegate, OBJC_ASSOCIATION_ASSIGN);
        
        // invoke old method, set the delegate itself
        function(target, @selector(setDelegate:), target);
    }));
     */
}

-(void) __Hook_setDelegate:(id<UIWebViewDelegate>)delegate {
    objc_setAssociatedObject(self, key_delegate, delegate, OBJC_ASSOCIATION_ASSIGN);
    
    [self __Hook_setDelegate:self];
}

-(id<UIWebViewDelegate>) delegate {
    return objc_getAssociatedObject(self, key_delegate);
}

#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // external custom
    if ([self respondsToSelector:@selector(delegateShouldStartWithRequest:navigationType:)]) {
        if (![self delegateShouldStartWithRequest:request navigationType:navigationType]) {
            return NO;
        }
    }
    
    // call external delegate methods
    BOOL result = YES;
    id<UIWebViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        result = [delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    // external custom
    if ([self respondsToSelector:@selector(delegateStartedWithRequest:navigationType:result:)]) {
        [self delegateStartedWithRequest:request navigationType:navigationType result:result];
    }
    
    return result;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // external custom
    if ([self respondsToSelector:@selector(delegateDidStartLoad)]) {
        [self delegateDidStartLoad];
    }
    
    // call external delegate methods
    id<UIWebViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [delegate webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // external custom
    if ([self respondsToSelector:@selector(delegateDidFinishLoad)]) {
        [self delegateDidFinishLoad];
    }
    
    // call external delegate methods
    id<UIWebViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [delegate webViewDidFinishLoad:webView];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // external custom
    if ([self respondsToSelector:@selector(delegateDidFailLoadWithError:)]) {
        [self delegateDidFailLoadWithError:error];
    }
    
    // call external delegate methods
    id<UIWebViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [delegate webView:webView didFailLoadWithError:error];
    }
}

@end

#pragma clang diagnostic pop
