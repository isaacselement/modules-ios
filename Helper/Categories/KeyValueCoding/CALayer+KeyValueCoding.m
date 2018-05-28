#import "CALayer+KeyValueCoding.h"
#import <objc/runtime.h>

@implementation CALayer (KeyValueCoding)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(setValue:forUndefinedKey:));
    Method newMethod = class_getInstanceMethod([self class], @selector(__Hook_setValue:forUndefinedKey:));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)__Hook_setValue:(id)value forUndefinedKey:(NSString *)key
{
    id oldValue = [self valueForKey: key];
    if (value == oldValue) {
        return;
    }
    
    // for CALayer
    if ([oldValue isKindOfClass:[CALayer class]]) {
        [(CALayer *)oldValue removeFromSuperlayer];
    }
    if ([value isKindOfClass:[CALayer class]]) {
        [self addSublayer:(CALayer *)value];
    }
    
    [self __Hook_setValue:value forUndefinedKey:key];
}

@end
