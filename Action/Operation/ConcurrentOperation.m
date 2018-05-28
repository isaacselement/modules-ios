#import "ConcurrentOperation.h"

@implementation ConcurrentOperation
{
    BOOL executing;
    BOOL finished;
}


-(BOOL)isConcurrent
{
    return YES;
}

-(BOOL)isAsynchronous
{
    return YES;
}

-(BOOL)isExecuting
{
    return executing;
}

-(BOOL)isFinished
{
    return finished;
}


-(void)start
{
    // Always check for cancellation before launching the task.
    if ([self isCancelled]) {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey: @"isFinished"];
        finished = YES;
        [self didChangeValueForKey: @"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey: @"isExecuting"];
    
    if (self.operationBlock) {
        self.operationBlock();
    } else {
        // Subclass could only over write this main method to support Async/Concurrent
        [self main];
    }
    
    executing = YES;
    [self didChangeValueForKey: @"isExecuting"];
}



#pragma mark - Public Methods

-(void) completeOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}




@end
