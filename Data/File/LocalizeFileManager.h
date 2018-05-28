#import <Foundation/Foundation.h>

@interface LocalizeFileManager : NSObject

+(void) writeStringsFile: (NSDictionary*)outterContents ;

+(void) writeStringsFile: (NSDictionary*)contents toPath:(NSString*)filePath ;

+(NSMutableDictionary*) readStringsFile: (NSString*)filePath ;
+(NSMutableDictionary*) readStringsFiles: (NSArray*)filePaths ;

@end
