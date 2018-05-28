#import <Foundation/Foundation.h>

@interface ConcurrentOperation : NSOperation



@property (copy) void(^operationBlock)();



#pragma mark - Public Methods

-(void) completeOperation;



@end
