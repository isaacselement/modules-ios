#import "CollectionHelper.h"

@implementation CollectionHelper


#pragma mark - JSON

// collection may be Dictionary, Array, Set ...
+(NSString*) convertJSONObjectToJSONString: (id)collection
{
    return [self convertJSONObjectToJSONString: collection compress:YES];
}

+(NSString*) convertJSONObjectToJSONString: (id)collection compress:(BOOL)compress
{
    NSUInteger options = compress ? 0 : NSJSONWritingPrettyPrinted;
    if (! collection) return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:collection options:options error:&error];
    if (error) {
        NSLog(@"CollectionHelper ConvertToJSONString Error!!! ~~~ %@", error);
        return nil;
    }
    NSString *jsonStrings = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStrings;
}



+(id) convertJSONStringToJSONObject: (NSString*)jsonString
{
    if (! jsonString) return nil;
    NSError* error = nil;
    NSData* jsonData = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"CollectionHelper convertJSONStringToJSONObject Error!!! ~~~ %@", error);
        return nil;
    }
    return jsonObject;
}


#pragma mark -
// temporary
+(NSMutableArray*) dictionaryToArray: (NSDictionary*)dictionary
{
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSString* key in dictionary) {
        id obj = [dictionary objectForKey: key];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray*)obj;
            [result addObjectsFromArray: array];
        } else {
            [result addObject: obj];
        }
        
    }
    return result;
}

@end
