#import <Foundation/Foundation.h>

@interface SharedOperationQueue : NSOperationQueue


+(SharedOperationQueue*) sharedInstance;


-(void)executeOperation:(NSOperation*)op;

-(void)executeOperation:(NSOperation*)op delay:(NSTimeInterval)delay;

-(void)cancelOperation:(NSOperation*)op;


@end
