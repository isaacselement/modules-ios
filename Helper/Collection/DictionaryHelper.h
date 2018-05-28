#import <Foundation/Foundation.h>

typedef BOOL (^DictionaryCombineHandler)(NSString* sourceKey, NSMutableDictionary* destination, NSDictionary* source);

@interface DictionaryHelper : NSObject

+(void) setCombineHandler:(DictionaryCombineHandler)handler;

+(NSMutableDictionary*) combines: (NSDictionary*)destination with:(NSDictionary*)source;
+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source;

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source handler:(DictionaryCombineHandler)handler;


#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts;

+(void) replaceKeys: (NSMutableDictionary*)dictionary keys:(NSArray*)keys withKeys:(NSArray*)withKeys;
+(void) replaceKey: (NSMutableDictionary*)dictionary key:(NSString*)key withKey:(NSString*)withKey;

#pragma mark - About Values

+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz;
+(NSMutableDictionary*) subtract: (NSDictionary*)dictionary keys:(NSArray*)keys;


+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz;
+(NSMutableDictionary*) extract: (NSDictionary*)dictionary withType:(Class)clazz ;


+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj ;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary filter:(BOOL(^)(id value))filter ;

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary;


#pragma mark - About Keys and Values
+(NSMutableDictionary*) convertToOneDimensionDictionary: (NSDictionary*)dictionary;

+(NSMutableDictionary*) convert: (NSArray*)values keys:(NSArray*)keys;

+(void) duplicate: (NSMutableDictionary*)dictionary copy:(NSString*)copy with:(NSString*)with;
+(void) delete: (NSMutableDictionary*)dictionary content:(id)content;

#pragma mark - Get the depth
+(NSInteger) getTheDepth: (NSDictionary*)dictionary;


@end
