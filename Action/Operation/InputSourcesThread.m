#import "InputSourcesThread.h"

@implementation InputSourcesThread



@synthesize shouldKeepRunning;



static InputSourcesThread* sharedInstance = nil;

+(InputSourcesThread*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InputSourcesThread alloc] init];
        [sharedInstance start];
    });
    return sharedInstance;
}




#pragma mark - Public Methods

-(void) stopRunning
{
    shouldKeepRunning = NO;
    [self performSelector: @selector(emptySelector) onThread:self withObject:nil waitUntilDone:NO];
}
-(void) emptySelector {
    // Empty ... Just for stopRunning
}

-(void) execute:(NSTimeInterval)delay :(void(^)(void))block
{
    [self performSelector:@selector(execute:) withObject:block afterDelay:delay];
}
-(void) execute:(void(^)(void))block
{
    //    [block invoke];
    [block performSelector:@selector(invoke) onThread:self withObject:nil waitUntilDone:NO];
}

-(void) cancel:(void(^)(void))block
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(execute:) object:block];
}

#pragma mark - Override Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        shouldKeepRunning = YES;
    }
    return self;
}


// http://stackoverflow.com/questions/2584394/iphone-how-to-use-performselectoronthreadwithobjectwaituntildone-method/2615480#2615480
// http://stackoverflow.com/questions/2584394/iphone-how-to-use-performselectoronthreadwithobjectwaituntildone-method/2791826#2791826

-(void)main
{
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        while (shouldKeepRunning) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"+++++++++++++++++++++++++++");
        }
    }
}


@end
