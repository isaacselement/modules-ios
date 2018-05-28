#import "DictionaryHelper.h"

#import "ArrayHelper.h"
#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"

@implementation DictionaryHelper

static BOOL (^combineHandler)(NSString* key, NSMutableDictionary* destination, NSDictionary* source) = nil;
+(void) setCombineHandler:(DictionaryCombineHandler)handler
{
    combineHandler = handler;
}

// so now, the source is not deep copy , then the result is not fully deep copy.
// if you want to the result is fully deep copy , you should pass the [self deepCopy: source] as source
+(NSMutableDictionary*) combines: (NSDictionary*)destination with:(NSDictionary*)source {
    NSMutableDictionary* repository = [destination deepCopy];
    [self combine: repository with:source];
    return repository;
}

// the destination should has been deep copied / or element are mutable recursively
+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source {
    [self combine: destination with:source handler:combineHandler];
}

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source handler:(DictionaryCombineHandler)handler
{
    id key = nil;
    NSEnumerator* sourceEnumerator = [source keyEnumerator];
    while ((key = [sourceEnumerator nextObject])) {
        NSObject* sourceObj = source[key];
        NSObject* destinationObj = destination[key];
        
        if ([sourceObj isKindOfClass: [NSDictionary class]] && [destinationObj isKindOfClass: [NSDictionary class]]) {
            [DictionaryHelper combine: (NSMutableDictionary*)destinationObj with:(NSDictionary*)sourceObj handler:handler];
        } else if ([sourceObj isKindOfClass:[NSArray class]] && [destinationObj isKindOfClass:[NSArray class]]) {
            [ArrayHelper combine:(NSMutableArray*)destinationObj with:(NSArray*)sourceObj];
        } else {
            if (handler && !handler(key, destination, source)) continue;
            [destination setObject: sourceObj forKey: key];
        }
    }
}



#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary
{
    if (! dictionary) return nil;
    NSArray* allKeys = [dictionary allKeys];
    NSMutableArray* temp = [NSMutableArray arrayWithArray: allKeys];
    NSArray* sortedKeys = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return sortedKeys;
}


+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail
{
    return [self tailKeys: dictionary with:tail excepts:nil];
}


+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSString* key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString* newKey = [excepts containsObject: key] ? key : [key stringByAppendingString:tail];
        [result setObject: value forKey: newKey];
    }
    return result;
}

+(void) replaceKeys: (NSMutableDictionary*)dictionary keys:(NSArray*)keys withKeys:(NSArray*)withKeys
{
    if (! [dictionary isKindOfClass:[NSMutableDictionary class]]) return;
    
    for (int i = 0; i < keys.count; i ++) {
        NSString* key = keys[i];
        NSString* withKey = withKeys[i];
        [self replaceKey: dictionary key:key withKey:withKey];
    }
}

+(void) replaceKey: (NSMutableDictionary*)dictionary key:(NSString*)key withKey:(NSString*)withKey
{
    id content = [dictionary objectForKey: key];
    [dictionary removeObjectForKey: key];
    [dictionary setObject: content forKey:withKey];
}

#pragma mark - About Values

// return the subtract contents
+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSArray* keys = [dictionary allKeys];
    for (NSString* key in keys) {
        id value = [dictionary objectForKey: key];
        
        if ([value isKindOfClass:clazz]) {
            [result setObject: value forKey:key];
            [dictionary removeObjectForKey: key];
        }
    }
    return result;
}

+(NSMutableDictionary*) subtract: (NSDictionary*)dictionary keys:(NSArray*)keys
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSString* key in keys) {
        id value = [dictionary objectForKey: key];
        if (value) {
            [result setObject: value forKey:key];
        }
    }
    return result;
}

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if ([value isKindOfClass:clazz]) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}

+(NSMutableDictionary*) extract: (NSDictionary*)dictionary withType:(Class)clazz {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        if ([value isKindOfClass:clazz]) {
            [result setObject: value forKey:key];
        };
        
    }
    return result;
}



+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if (value == filterObj) continue;
        
        // http://stackoverflow.com/questions/2293859/checking-for-equality-in-objective-c
        
        if ([value isEqual: filterObj]) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary filter:(BOOL(^)(id value))filter {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if (filter(value)) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = dictionary[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        [result setObject: value forKey:key];
    }
    return result;
}



#pragma mark - About Keys and Values

// For Two Dimension Dictioanry
// i.e :
// { "HumanResource":{"EmployeeCHOrder":["YGYDB201312181638"],"Employee":[]},  "Finance":{"FinanceSalaryCHOrder":[]}, } -> {"EmployeeCHOrder":["YGYDB201312181638"], "Employee":[], "FinanceSalaryCHOrder":[]}
+(NSMutableDictionary*) convertToOneDimensionDictionary: (NSDictionary*)dictionary
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        NSDictionary* value = [dictionary objectForKey: key];
        for (NSString* subKey in value) {
            id subValue = [value objectForKey: subKey];
            [result setObject: subValue forKey:subKey];
        }
    }
    return result;
}


+(NSMutableDictionary*) convert: (NSArray*)values keys:(NSArray*)keys
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < values.count; i++) {
        id obj = values[i];
        id key = [keys safeObjectAtIndex: i];
        if (key) {
            [dictionary setObject: obj forKey:key];
        }
    }
    return dictionary.count ? dictionary : nil;
}

// {"a":["a", "1", "2"], "b": "c"}  -- copy:"a", with:"A" --> {"a":["a", "A", "1", "2"], "b": "c"}
+(void) duplicate: (NSMutableDictionary*)dictionary copy:(NSString*)copy with:(NSString*)with
{
    NSArray* allKeys = [dictionary allKeys];
    for (NSUInteger i = 0; i < allKeys.count; i++) {
        NSString* key = allKeys[i];
        id value = dictionary[key];
        if ([value isKindOfClass:[NSMutableArray class]]) {
            [ArrayHelper duplicate: value copy:copy with:with];
        } else if ([value isKindOfClass:[NSMutableDictionary class]]) {
            [self duplicate: value copy:copy with:with];
        }
    }
}
+(void) delete: (NSMutableDictionary*)dictionary content:(id)content
{
    NSArray* allKeys = [dictionary allKeys];
    for (NSUInteger i = 0; i < allKeys.count; i++) {
        NSString* key = allKeys[i];
        id value = dictionary[key];
        if ([value isEqual: content]) {
            [dictionary removeObjectForKey:key];
            i--;
        }else if ([value isKindOfClass:[NSMutableArray class]]) {
            [ArrayHelper delete:value content:content];
        } else if ([value isKindOfClass:[NSMutableDictionary class]]) {
            [self delete:value content:content];
        }
    }
}

#pragma mark - Get the depth
// dictionary with dictionary in it.
+(NSInteger) getTheDepth: (NSDictionary*)dictionary
{
    NSInteger depth = 1 ;
    [self iterateDictionary: dictionary depth:&depth];
    return depth;
}
// so to be optimize
+(void) iterateDictionary: (NSDictionary*)dictionary depth:(NSInteger*)depth
{
    *depth = *depth + 1;
    for (NSString* key in dictionary) {
        id content = dictionary[key];
        if ([content isKindOfClass:[NSDictionary class]]) {
            [self iterateDictionary: content depth:depth];
            break;      // just get one to test , so , you must has the same structure in it.
        }
    }
}


@end
