#import <CoreMotion/CoreMotion.h>

@interface SharedMotionManager : CMMotionManager

+(SharedMotionManager*) sharedInstance;

@end
