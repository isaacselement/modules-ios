#import "ActionExecutorBase.h"

@implementation ActionExecutorBase

-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times {
    for (int i = 0; i < objects.count; i++){
        NSObject* object = [objects objectAtIndex: i];
        [self execute: config onObject:object];
    }
}

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {}

@end
