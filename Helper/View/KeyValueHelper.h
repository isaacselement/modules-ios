#import <UIKit/UIKit.h>


typedef id(^KeyValueCodingTranslator)(NSObject* obj, id value, NSString* type, NSString* keyPath);

@interface KeyValueHelper : NSObject

-(KeyValueCodingTranslator) translateValueHandler;

-(void) setTranslateValueHandler:(KeyValueCodingTranslator)handler;

#pragma mark - Public Methods

-(void) setValues:(NSDictionary*)config object:(NSObject*)object;

-(void) setValue:(id)value keyPath:(NSString*)keyPath object:(NSObject*)object;

-(id) translateValue:(id)value type:(NSString*)type object:(NSObject*)object keyPath:(NSString*)keyPath;

#pragma mark - Class Methods

+(KeyValueHelper*) sharedInstance;

+(void) setSharedInstance:(KeyValueHelper*)obj;

+(NSMutableDictionary *)getClassPropertieTypes:(Class)clazz;

+(id) translateValue:(id)value type:(NSString*)type;

#pragma mark - Utilities Methods;

+(UIImage*) getUIImageByPath: (NSString*)path;

+(NSString*) getResourcePath: (NSString*)path;

@end