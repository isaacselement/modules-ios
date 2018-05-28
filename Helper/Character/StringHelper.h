#import <Foundation/Foundation.h>


#define STRINGS(string, ...) [StringHelper appendStrings:string, ##__VA_ARGS__, nil]


@interface StringHelper : NSObject

+(int) numberOfUpperCaseCharacter: (NSString*)string ;

+(BOOL) isNumeric:(NSString*)string;

+(NSString*) appendStrings: (NSString*)string, ... NS_REQUIRES_NIL_TERMINATION;

+(BOOL) isContainsEnglish:(NSString *)string ;

+(int) getChineseCount: (NSString*)string;

+(BOOL) isContainsChinese:(NSString*)string;

+(NSMutableString*) getChinese:(NSString*)string;

+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount;

+(NSMutableString*) separate:(NSString*)string spaceMeta:(NSString*)spaceMeta;


#pragma mark -

+(NSString*) stringBetweenString:(NSString*)string start:(NSString*)start end:(NSString*)end;

+(NSMutableArray*)stringsBetweenString:(NSString*)string start:(NSString*)start end:(NSString*)end;

+(void) iterateString: (NSString*)string handler:(BOOL(^)(int index, unichar character))handler;

@end
