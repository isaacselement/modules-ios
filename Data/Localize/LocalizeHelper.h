#import <Foundation/Foundation.h>

#define LOCALIZE_KEYS_PREFIX     @"KEYS."

@interface LocalizeHelper : NSObject

+(NSString*) connect: (NSString*)key, ... NS_REQUIRES_NIL_TERMINATION;

+(NSString*) connectKeys: (NSArray*)keys;

+(NSMutableArray*) localize: (NSArray*)array;

@end
