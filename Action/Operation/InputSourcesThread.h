#import <Foundation/Foundation.h>

@interface InputSourcesThread : NSThread



@property (assign, readonly) BOOL shouldKeepRunning;



+(InputSourcesThread*) sharedInstance;

-(void) stopRunning;

-(void) execute:(NSTimeInterval)delay :(void(^)(void))block;
-(void) execute:(void(^)(void))block;
-(void) cancel:(void(^)(void))block;

@end