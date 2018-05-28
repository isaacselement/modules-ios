#import "ArrayHelper.h"
#import "DictionaryHelper.h"

#import "NSArray+Additions.h"

@implementation ArrayHelper

static BOOL (^combineHandler)(int index, NSMutableArray* destination, NSArray* source) = nil;
+(void) setCombineHandler:(BOOL (^)(int index, NSMutableArray* destination, NSArray* source))handler
{
    combineHandler = handler;
}

+(NSMutableArray*) combines: (NSArray*)destination with:(NSArray*)source {
    NSMutableArray* repository = [destination deepCopy];
    [self combine: repository with:source];
    return repository;
}

// the destination should has been deep copied / or element are mutable recursively
+(void) combine: (NSMutableArray*)destination with:(NSArray*)source {
    [self combine:destination with:source handler:combineHandler];
}

+(void) combine: (NSMutableArray*)destination with:(NSArray*)source handler:(BOOL (^)(int index, NSMutableArray* destination, NSArray* source))handler
{
    for (int i = 0; i < source.count; i++) {
        NSObject* sourceObj = source[i];
        NSObject* destinationObj = [destination safeObjectAtIndex:i];
                
        if ([sourceObj isKindOfClass: [NSDictionary class]] && [destinationObj isKindOfClass: [NSDictionary class]]) {
            [DictionaryHelper combine: (NSMutableDictionary*)destinationObj with:(NSDictionary*)sourceObj];
        } else if ([sourceObj isKindOfClass:[NSArray class]] && [destinationObj isKindOfClass:[NSArray class]]) {
            [ArrayHelper combine:(NSMutableArray*)destinationObj with:(NSArray*)sourceObj handler:handler];
        } else {
            
            if (handler && ! handler(i, destination, source)) {
                return;
            }
            
            // do add , when handler == nil , or handler(...) return YES
            if (i < destination.count) {
                [destination replaceObjectAtIndex: i withObject:sourceObj];
            } else {
                // destinationObj == nil
                [destination addObject: sourceObj];
            }
            
        }
    }
}

// [ArrayHelper add: array objs:@"1", nil] . Do not forget the "nil"
+(void) add: (NSMutableArray*)repository objs:(id)obj, ... {
    id arg = nil;
    va_list params;
    if (obj) {
        [repository addObject: obj];
        va_start(params, obj);
        while ((arg = va_arg(params, id))) {
            if (arg) [repository addObject: arg];
        }
        va_end(params);
    }
}

+(BOOL) isTwoDimension: (NSArray*)array
{
    // not one dimension and not three dimension
    return [[array firstObject] isKindOfClass: [NSArray class]] && (![[[array firstObject] firstObject] isKindOfClass:[NSArray class]]);
}

+(BOOL) isThreeDimension: (NSArray*)array
{
    // three dimension and not for dimension
    return [[array firstObject] isKindOfClass: [NSArray class]] && [[[array firstObject] firstObject] isKindOfClass:[NSArray class]] && (![[[[array firstObject] firstObject] firstObject] isKindOfClass:[NSArray class]]);
}

// array is tow dimension, you have to check it outside
+(NSMutableArray*) translateToOneDimension: (NSArray*)array
{
    NSMutableArray* results = [NSMutableArray array];
    if ([ArrayHelper isTwoDimension: array]) {
        for (NSUInteger i = 0; i < array.count; i++) {
            NSArray* innerArray = array[i];
            [results addObjectsFromArray: innerArray];
        }
    } else {
        [results setArray: array];
    }
    
    return results;
}

// matrix is tow diemnsion
+(int) getMaxCount: (NSArray*)matrixs
{
    NSUInteger max = matrixs.count;
    for(NSArray* array in matrixs) {
        NSUInteger count = array.count;
        if (count > max) max = count;
    }
    return (int)max;
}

#pragma mark - Handler Contents

// not enclude the index element itself, just after it
// i.e. @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"] -> afterIndex 3 -> @[@"0",@"1",@"2",@"3"]
+(void) removeElements: (NSMutableArray*)array afterIndex:(int)index
{
    int count = (int)array.count;
    if (count == 0 || index < 0 || count-1 <= index ) return;
    int length = count - 1 - index;
    [array removeObjectsInRange: NSMakeRange(index + 1, length)];
}


+(void) shuffle: (NSMutableArray*)array {
    int count = (int)[array count];
    for (int i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

// array: ["4","5","6","1","2"], frontContents:["1","2", "3", "100"]
// return ["1","2", "4","5","6"], just put the frontContents to front
+(NSMutableArray*) reRangeContents: (NSArray*)array frontContents:(NSArray*)frontContents
{
    NSMutableArray* newContents = [array deepCopy];
    NSArray* intersections = [ArrayHelper intersect: array with:frontContents];
    [ArrayHelper subtract: newContents with: intersections];             // remove the front keys in array
    [newContents insertObjects: intersections atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){0, intersections.count}]];  // then insert the front keys in the front
    return newContents;
}

+(void) subtract:(NSMutableArray*)array with:(NSArray*)subtracts
{
    for (id element in subtracts) {
        if ([array containsObject: element]){
            [array removeObject: element];
        }
    }
}

+(NSMutableArray*) intersect: (NSArray*)array with:(NSArray*)arrayObj
{
    NSMutableArray* result = [NSMutableArray array];
    for (NSUInteger i = 0; i < arrayObj.count; i++) {
        id obj = arrayObj[i];
        if ([array containsObject: obj]) {
            [result addObject: obj];
        }
    }
    return result;
}


// remove the duplicate objects & maintain the orders
+(NSMutableArray*) eliminateDuplicates: (NSArray*)array
{
    if (! array) return nil;
    
    NSMutableArray* results = [NSMutableArray array];
    for (NSUInteger i = 0; i < array.count; i++) {
        id obj = array[i];
        if (![results containsObject: obj]) {
            [results addObject: obj];
        }
    }
    return  results;
}


+(void) duplicate: (NSMutableArray*)array copy:(NSString*)copy with:(NSString*)with
{
    NSArray* temp = [NSArray arrayWithArray: array];
    for (NSUInteger i = 0; i < temp.count; i++) {
        id value = array[i];
        if ([value isKindOfClass:[NSString class]] && [value isEqualToString: copy]) {
            [array addObject: with];
        } else if ([value isKindOfClass:[NSMutableArray class]]) {
            [self duplicate: value copy:copy with:with];
        } else if ([value isKindOfClass:[NSMutableDictionary class]]) {
            [DictionaryHelper duplicate: value copy:copy with:with];
        }
    }
}
+(void) delete: (NSMutableArray*)array content:(id)content
{
    for (NSUInteger i = 0; i < array.count; i++) {
        id value = array[i];
        if ([value isKindOfClass:[NSMutableArray class]]) {
            [self delete:value content:content];
        } else if ([value isKindOfClass:[NSMutableDictionary class]]) {
            [DictionaryHelper delete:value content:content];
        } else if ([array containsObject: content]) {
            [array removeObject: content];
            i--;
        }
    }
}





#pragma mark - 

// array with string
+(NSArray*) sort:(NSArray*)array
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray: array];
    NSArray* result = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare: obj2];
    }];
    return result;
}

// array with [[1,0], [5,4]]
+(void) sortArray: (NSMutableArray*)array asc:(BOOL)isASC
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* array1 = (NSArray*)obj1;
        NSArray* array2 = (NSArray*)obj2;
        NSNumber* outerIndex1 = [array1 firstObject];
        NSNumber* outerIndex2 = [array2 firstObject];
        NSNumber* innerIndex1 = [array1 lastObject];
        NSNumber* innerIndex2 = [array2 lastObject];
        NSComparisonResult result1 = isASC ? [innerIndex1 compare: innerIndex2] : [innerIndex2 compare: innerIndex1] ;
        NSComparisonResult result2 = isASC ? [outerIndex1 compare: outerIndex2] : [outerIndex2 compare: outerIndex1] ;
        return ([outerIndex1 compare: outerIndex2] == NSOrderedSame) ? result1 : result2;
    }];
}


#pragma mark - 


+(void) printMultiDimensionArrayToJsonFormat: (NSArray*)array
{
    if ([self isTwoDimension: array]) {
        
        printf("[\n");
        for (int i = 0; i < [array count]; i++) {
            NSArray* coordinate = array[i];
            int row = [[coordinate firstObject] intValue];
            int columne = [[coordinate lastObject] intValue];
            printf("[%d,%d]", row, columne);
        }
        printf("]\n");
        
    }
    
    else
        
    if ([self isThreeDimension: array]) {
        
        printf("[\n");
        for (int i = 0; i < [array count]; i++) {
            printf("[ ");
            for (int j = 0; j < [array[i] count]; j++) {
                NSArray* coordinate = array[i][j];
                int row = [[coordinate firstObject] intValue];
                int columne = [[coordinate lastObject] intValue];
                printf("[%d,%d]", row, columne);
            }
            printf(" ]\n");
        }
        printf("]\n");
        
    }
}

@end


