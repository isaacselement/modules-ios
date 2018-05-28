#import "HTTPRequestBase.h"


// From http://tomcat.apache.org/tomcat-7.0-doc/config/http.html , 'connectionTimeout' is 20 seconds (i.e. 20000 milliSecond) in server.xml
#define NetworkTimeOutInterval 20


@implementation HTTPRequestBase
{
    NSURLConnection* urlconnection;
    NSOperationQueue* operationQueue;
    
    void(^completeHandlerBlock)(HTTPRequestBase* httpRequest, NSURLResponse* response, NSData* data, NSError* connectionError);
    
    NSMutableData* connectionReceivedData;
    NSURLResponse* connectionResponse;
    NSError* connectionError;
}

@synthesize delegate;


- (id)init {
    @throw [NSException exceptionWithName:@"Reject Exception" reason:@"Invoke initWithURLString:parameters: instead " userInfo:nil];
    return nil;
}

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters {
    return [self initWithURLString:urlString parameters:parameters timeoutInterval:NetworkTimeOutInterval];
}

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters timeoutInterval:(NSTimeInterval)timeoutInterval {
    if (!urlString) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        NSURL* url = [self getURL: urlString parameters:parameters];
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval] ;
        [self applyRequest: urlRequest parameters:parameters];
        _request = urlRequest;
        
        _identification = [NSString stringWithFormat: @"%p", self];  // default
        
        connectionReceivedData = [[NSMutableData alloc] initWithCapacity:0];
    }
    return self;
}





#pragma mark - NSURLConnection

-(void) cancelRequest {
    [urlconnection cancel];
}

-(void) startRequest: (void (^)(HTTPRequestBase* httpRequest, NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    completeHandlerBlock = completeHandler;
    [self startRequest];
}

-(void) startRequest {
    [self startRequestWithRunLoop: nil];
}

-(void) startRequestWithRunLoop: (NSRunLoop*)runLoop
{
    if (!runLoop) {
        runLoop = [NSRunLoop currentRunLoop];
    }
    urlconnection = [[NSURLConnection alloc] initWithRequest: self.request delegate:self startImmediately:NO];
    [urlconnection scheduleInRunLoop:runLoop forMode:NSRunLoopCommonModes];
    [urlconnection start];
}





#pragma mark - NSURLRequest

// this one can not be cancel using [operationQueue cancelAllOperations]
-(void) startAsynchronousRequest: (void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    if (!operationQueue) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    [self startAsynchronousRequestWithQueue:operationQueue handler:completeHandler];
}

-(void) startAsynchronousRequestWithQueue: (NSOperationQueue*)queue handler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    [NSURLConnection sendAsynchronousRequest: self.request queue:queue completionHandler:completeHandler];
}

-(NSData*) startSynchronousRequest
{
    NSError* error = nil;
    NSURLResponse* response = nil;
    return [NSURLConnection sendSynchronousRequest: self.request returningResponse:&response error:&error];
}

-(NSData*) startSynchronousRequest:(NSURLResponse **)response error:(NSError **)error;
{
    return [NSURLConnection sendSynchronousRequest: self.request returningResponse:response error:error];
}





#pragma mark - SubClass Overwrite Methods

// Optional
-(NSURL*) getURL: (NSString*)urlString parameters:(NSDictionary*)parameters {
    NSString* encodeURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString: encodeURL];
}

// Required
-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {
}






#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    connectionError = error;
    
    // delegate
    if (completeHandlerBlock) {
        completeHandlerBlock(self , nil, nil, connectionError);
    }
    
    else
    
    if (delegate && [delegate respondsToSelector: @selector(didFailRequestWithError:error:)] ) {
        [delegate didFailRequestWithError: self error:error];
    }
}








#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    connectionResponse = response;
    
    // delegate
    if (delegate && [delegate respondsToSelector: @selector(didSucceedRequest:response:)] ) {
        [delegate didSucceedRequest: self response:(NSHTTPURLResponse*)response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connectionReceivedData appendData: data];
    
    // when downloading the large file, write it to file, then clear the cache data, append the the data to the end of file
//    [NSFileHandle seekToEndOfFile];
//    [NSFileHandle writeData: connectionReceivedData];
//    [connectionReceivedData setLength: 0];
//    [connectionReceivedData setData: nil];
    
    // delegate
    if (delegate && [delegate respondsToSelector: @selector(didReceivePieceData:data:)] ) {
        [delegate didReceivePieceData: self data:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (completeHandlerBlock) {
        completeHandlerBlock(self, connectionResponse, connectionReceivedData, connectionError);
    }
    
    else
        
    if (delegate && [delegate respondsToSelector: @selector(didFinishReceiveData:data:)]) {
        [delegate didFinishReceiveData: self data:connectionReceivedData];
    }
}

@end
