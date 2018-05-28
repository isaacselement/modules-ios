#import <Foundation/Foundation.h>

@interface CollectionHelper : NSObject

#pragma mark - JSON
+(NSString*) convertJSONObjectToJSONString: (id)collection;
+(NSString*) convertJSONObjectToJSONString: (id)collection compress:(BOOL)compress;

+(id) convertJSONStringToJSONObject: (NSString*)jsonString;


#pragma mark -
+(NSMutableArray*) dictionaryToArray: (NSDictionary*)dictionary;

@end
