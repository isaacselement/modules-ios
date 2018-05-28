#import "SharedOperationQueue.h"

@implementation SharedOperationQueue



static SharedOperationQueue* sharedInstance = nil;

+(SharedOperationQueue*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedOperationQueue alloc] init];
    });
    return sharedInstance;
}

-(void)executeOperation:(NSOperation*)op
{
    [self executeOperation: op delay:0];
}

-(void)executeOperation:(NSOperation*)op delay:(NSTimeInterval)delay
{
    //    [self performSelector:@selector(addOperation:) withObject:op afterDelay:delay];       // Failed, cause the runloop problem
    //    cause the runloop issue , i have to put it to main thread main queue to fire the 'performSelector:withObject:afterDelay:' input source
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(addOperation:) withObject:op afterDelay:delay];
    });
}

-(void)cancelOperation:(NSOperation*)op
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addOperation:) object:op];
    [op cancel];
}

-(void)cancelAllOperations
{
    [super cancelAllOperations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end
