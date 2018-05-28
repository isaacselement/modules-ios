#import <Foundation/Foundation.h>

#define BUNDLEFILE_PATH(__file_name) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: __file_name]

@interface JsonFileManager : NSObject


+(id) getJsonFromFile: (NSString*)jsonFileName;
+(id) getJsonFromPath: (NSString*)jsonFilePath;

@end
