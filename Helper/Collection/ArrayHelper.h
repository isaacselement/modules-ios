#import <Foundation/Foundation.h>

@interface ArrayHelper : NSObject

+(void) setCombineHandler:(BOOL (^)(int index, NSMutableArray* destination, NSArray* source))handler;

+(NSMutableArray*) combines: (NSArray*)destination with:(NSArray*)source;

+(void) combine: (NSMutableArray*)destination with:(NSArray*)source;

+(void) combine: (NSMutableArray*)destination with:(NSArray*)source handler:(BOOL (^)(int index, NSMutableArray* destination, NSArray* source))handler;



+(void) add: (NSMutableArray*)repository objs:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;

+(BOOL) isTwoDimension: (NSArray*)array;
+(BOOL) isThreeDimension: (NSArray*)array;
+(NSMutableArray*) translateToOneDimension: (NSArray*)array;
+(int) getMaxCount: (NSArray*)matrixs;

#pragma mark - Handler Contents
+(void) removeElements: (NSMutableArray*)array afterIndex:(int)index;

+(void) shuffle: (NSMutableArray*)array ;

+(NSMutableArray*) reRangeContents: (NSArray*)array frontContents:(NSArray*)frontContents;
+(void) subtract:(NSMutableArray*)array with:(NSArray*)subtracts;
+(NSMutableArray*) intersect: (NSArray*)array with:(NSArray*)arrayObj;

// remove the duplicate objects & maintain the orders
+(NSMutableArray*) eliminateDuplicates: (NSArray*)array;

+(void) duplicate: (NSMutableArray*)array copy:(NSString*)copy with:(NSString*)with;
+(void) delete: (NSMutableArray*)array content:(id)content;


#pragma mark -

+(NSArray*) sort:(NSArray*)array;
+(void) sortArray: (NSMutableArray*) array asc:(BOOL)isASC;



#pragma mark -


+(void) printMultiDimensionArrayToJsonFormat: (NSArray*)array;

@end

