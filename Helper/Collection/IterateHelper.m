#import "IterateHelper.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_3
#define RANDOMINT(x) arc4random_uniform(x)
#else
#define RANDOMINT(x) arc4random() % x
#endif

@implementation IterateHelper

+(void) iterate: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler {
    for (int i = 0; i < array.count; i++) {
        id obj = [array objectAtIndex: i];
        if (handler(i, obj, (int)array.count)) return;
    }
}

+(void) iterateRadom: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler {
    int radomIndex = RANDOMINT((int)array.count);
    for (int i = 0, m = radomIndex; i < array.count; i++, m++) {
        if (m >= array.count) m = 0;
        id obj = [array objectAtIndex: m];
        if (handler(i, obj, (int)array.count)) return;
    }
}

+(void) iterateDictionary:(NSDictionary*)dictionary handler:(BOOL (^)(id key, id value))handler
{
    for (NSString* key in dictionary) {
        id value = [dictionary objectForKey: key];
        if (handler(key, value)) return;
    }
}

#pragma mark - 
+(void) iterateTwoDimensionArray: (NSArray*)array handler:(BOOL(^)(NSUInteger outterIndex, NSUInteger innerIndex, id obj, NSUInteger outterCount, NSUInteger innerCount))handler
{
    NSUInteger outterCount = array.count;
    for (NSUInteger i = 0; i < outterCount; i++) {
        NSArray* innerArray = [array objectAtIndex:i];
        NSUInteger innerCount = innerArray.count;
        for (NSUInteger j = 0; j < innerCount; j++) {
            id obj = [innerArray objectAtIndex: j];
            if ( handler(i, j, obj, outterCount, innerCount) ) return;
        }
    }
}

@end
