#import <Foundation/Foundation.h>

@interface IterateHelper : NSObject

+(void) iterate: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler ;
+(void) iterateRadom: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler ;


+(void) iterateDictionary:(NSDictionary*)dictionary handler:(BOOL (^)(id key, id value))handler;



#pragma mark -
+(void) iterateTwoDimensionArray: (NSArray*)array handler:(BOOL(^)(NSUInteger outterIndex, NSUInteger innerIndex, id obj, NSUInteger outterCount, NSUInteger innerCount))handler;


@end
