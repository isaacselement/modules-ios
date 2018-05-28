#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"

@implementation NSArray (Additions)

- (id)safeObjectAtIndex:(NSUInteger)index {
    return index >= self.count ? nil : [self objectAtIndex: index];
}

- (NSArray *)reversedArray {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSString *)sortedJsonString {
    NSMutableArray *sortedValues = [NSMutableArray arrayWithArray:self];
    [sortedValues sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableString *jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:@"["];
    for (int i = 0; i < sortedValues.count; i++) {
        NSString *value = sortedValues[i];
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [(NSDictionary *)value sortedJsonString];
        } else if ([value isKindOfClass:[NSArray class]]) {
            value = [(NSArray *)value sortedJsonString];
        }
        
        [jsonString appendFormat:@"\"%@\"", value];
        [jsonString appendString:@","];
    }
    if ([jsonString length] > 2) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    [jsonString appendString:@"]"];
    return jsonString;
}

@end


@implementation NSArray (DeepCopy)

// Note here , this method do not copy the deepest element object, just copy array & dictionay
- (NSMutableArray *)deepCopy {
    NSMutableArray* destination = [NSMutableArray array];
    [self deepCopyTo:destination];
    return destination;
}

- (void)deepCopyTo:(NSMutableArray*)destination {
    for (int i = 0; i < self.count; i++) {
        id obj = [self objectAtIndex: i];
        
        if ([obj isKindOfClass: [NSArray class]]) {
            obj = [obj deepCopy];
        } else if ([obj isKindOfClass: [NSDictionary class]]) {
            obj = [(NSDictionary *)obj deepCopy];
        }
        [destination addObject: obj];
    }
}


@end
