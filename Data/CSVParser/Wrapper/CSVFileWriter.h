#import <Foundation/Foundation.h>

@interface CSVFileWriter : NSObject

+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields ;
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields append:(BOOL)append ;

@end
