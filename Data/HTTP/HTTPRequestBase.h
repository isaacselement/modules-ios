#import <Foundation/Foundation.h>

/*
 *
 * A wrapper of HTTP Post Request
 * When initial , URL String and parameters(can be null) is needed
 * Delegate is needed if you need the response header and data .
 *
 */

#define HTTP_RES_HEADER_COOKIE @"Set-Cookie"
#define HTTP_REQ_HEADER_COOKIE @"cookie"


@protocol HTTPRequestDelegate;

@interface HTTPRequestBase : NSObject <NSURLConnectionDataDelegate>

@property (strong, readonly) NSMutableURLRequest* request;
@property (strong) NSString* identification;
@property (weak) id<HTTPRequestDelegate> delegate;



// initial methods
-(id) initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters ;

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters timeoutInterval:(NSTimeInterval)timeoutInterval ;





// with NSURLConnection
// cancel request
-(void) cancelRequest ;
-(void) startRequest: (void (^)(HTTPRequestBase* httpRequest, NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler ;
-(void) startRequest ;
-(void) startRequestWithRunLoop: (NSRunLoop*)runLoop;


// with NSURLRequest and NSOperationQueue
-(void) startAsynchronousRequest: (void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler ;
-(void) startAsynchronousRequestWithQueue: (NSOperationQueue*)queue handler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler;


-(NSData*) startSynchronousRequest;
-(NSData*) startSynchronousRequest:(NSURLResponse **)response error:(NSError **)error;






#pragma mark - SubClass Overwrite Methods

// Optional
-(NSURL*) getURL: (NSString*)urlString parameters:(NSDictionary*)parameters ;

// Required
-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters;

@end





/**
 *
 *   HTTPRequestDelegate
 *
 */

@protocol HTTPRequestDelegate <NSObject>

@optional

-(void) didFailRequestWithError: (HTTPRequestBase*)request error:(NSError*)error ;
-(void) didSucceedRequest: (HTTPRequestBase*)request response:(NSHTTPURLResponse*)response;
-(void) didReceivePieceData: (HTTPRequestBase*)request data:(NSData*)data ;
-(void) didFinishReceiveData: (HTTPRequestBase*)request data:(NSData*)data;

@end
