#import "SharedMotionManager.h"

@implementation SharedMotionManager


static SharedMotionManager* sharedInstance = nil;

+(SharedMotionManager*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedMotionManager alloc] init];
    });
    return sharedInstance;
}


@end
