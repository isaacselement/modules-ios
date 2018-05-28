#import <Foundation/Foundation.h>

@interface NSTimer (Additions)

- (void)pause;
- (void)resume;
- (void)resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
