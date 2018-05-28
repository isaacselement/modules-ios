#import "NSDictionary+Additions.h"
#import "NSArray+Additions.h"

@implementation NSDictionary (Additions)

- (NSString *)sortedJsonString {
    NSArray *sortedKeys = [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableString *jsonString = [[NSMutableString alloc] init];
    [jsonString appendString:@"{"];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString *key = sortedKeys[i];
        [jsonString appendFormat:@"\"%@\"", key];
        [jsonString appendString:@":"];
        
        NSString *string = [self objectForKey:key];
        if ([string isKindOfClass:[NSDictionary class]]) {
            string = [(NSDictionary *)string sortedJsonString];
        } else if ([string isKindOfClass:[NSArray class]]) {
            string = [(NSArray *)string sortedJsonString];
        }
        
        [jsonString appendFormat:@"\"%@\"", string];
        [jsonString appendString:@","];
    }
    if ([jsonString length] > 2) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    [jsonString appendString:@"}"];
    return jsonString;
}

@end


@implementation NSDictionary (DeepCopy)

// Note here , this method do not copy the deepest element object, just copy array & dictionay
- (NSMutableDictionary *)deepCopy {
    NSMutableDictionary* destination = [NSMutableDictionary dictionary];
    [self deepCopyTo:destination];
    return destination;
}

- (void)deepCopyTo:(NSMutableDictionary*)destination {
    for (NSString* key in self) {
        id obj = [self objectForKey: key];
        
        if ([obj isKindOfClass: [NSDictionary class]]) {
            obj = [obj deepCopy];
        } else if ([obj isKindOfClass: [NSArray class]]) {
            obj = [(NSArray *)obj deepCopy];
        }
        [destination setObject: obj forKey:key];
    }
}


@end
