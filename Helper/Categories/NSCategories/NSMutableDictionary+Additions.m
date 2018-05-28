#import "NSMutableDictionary+Additions.h"

@implementation NSMutableDictionary (Additions)

- (id)getRemoveObjectForKey: (NSString *)key {
    id value = self[key];
    [self removeObjectForKey:key];
    return value;
}

@end
