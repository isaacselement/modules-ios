#import "InvocationExecutor.h"

@implementation InvocationExecutor

-(void)execute:(NSDictionary *)config objects:(NSArray *)objects values:(NSArray *)values times:(NSArray *)times durationsRep:(NSMutableArray *)durationsQueue beginTimesRep:(NSMutableArray *)beginTimesQueue
{
    for (int i = 0; i < objects.count; i++) {
        
        id object = [objects objectAtIndex: i];
        NSString* subObject = config[@"object"];
        if (subObject) {
            object = [object valueForKeyPath: subObject];
        }
        
        NSString* selectorString = config[@"selector"];
        SEL selector = NSSelectorFromString(selectorString);
        NSArray* values = config[@"values"];
        
        if ([object respondsToSelector:selector]) {
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
            [invocation setTarget: object];
            [invocation setSelector: selector];
            
            // ... set arguments
            for (int i = 0; i < values.count; i++) {
                id value = values[i];
                [invocation setArgument: &value atIndex:2 + i]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            }
            
            [invocation retainArguments];
//            [invocation invoke];
            
            if (i < times.count && [times[i] floatValue] != 0) {
                [invocation performSelector:@selector(invoke) withObject:nil afterDelay:[times[i] floatValue]];
            } else {
                [invocation invoke];
            }
        }
        
    }
}

@end
