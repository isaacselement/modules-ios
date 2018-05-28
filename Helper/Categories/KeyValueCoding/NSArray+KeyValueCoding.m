#import "NSArray+KeyValueCoding.h"
#import <objc/runtime.h>

@implementation NSArray (KeyValueCoding)

+(void) load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(valueForKey:));
    Method newMethod = class_getInstanceMethod([self class], @selector(__Hook_valueForKey:));
    method_exchangeImplementations(oldMethod, newMethod);
}

-(id) __Hook_valueForKey:(NSString *)key
{
    NSScanner *scanner = [NSScanner scannerWithString: key];
    BOOL isNumeric = [scanner scanFloat:NULL] && [scanner isAtEnd];
    if (isNumeric) {
        int index = [key intValue];
        return index >= self.count ? nil : [self objectAtIndex: index];
    }
    
    // else, call the original implementation
    return [self __Hook_valueForKey:key];
}

@end
