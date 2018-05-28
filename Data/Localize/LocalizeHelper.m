#import "LocalizeHelper.h"
#import "CategoriesLocalizer.h"

@implementation LocalizeHelper

+(NSString*) connect: (NSString*)key, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray* keys = [NSMutableArray array];

    va_list list;
    va_start(list, key);
    do {
        [keys addObject: key];
        key = va_arg(list, NSString*);
    } while (key);
    va_end(list);

    return [self connectKeys: keys];
}

+(NSString*) connectKeys: (NSArray*)keys
{
    return [LOCALIZE_KEYS_PREFIX stringByAppendingString: [keys componentsJoinedByString: LOCALIZE_KEY_CONNECTOR]];
}

// array with key
+(NSMutableArray*) localize: (NSArray*)array
{
    NSInteger count = array.count;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i++) {
        NSString* key = array[i];
        NSString* localizeValue = LOCALIZE_KEY(key);
        [results addObject: localizeValue];
    }
    return results;
}

@end
