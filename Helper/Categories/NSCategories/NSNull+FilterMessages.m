#import "NSNull+FilterMessages.h"

@implementation NSNull (FilterMessage)

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [NSNull instanceMethodSignatureForSelector: @selector(description)];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    id temp = nil;
    [anInvocation invokeWithTarget: temp];
}

@end
