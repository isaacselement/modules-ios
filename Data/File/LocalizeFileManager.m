#import "LocalizeFileManager.h"

@implementation LocalizeFileManager

/** @prama outterContents two dimensioin dictionary 
 
    outter keys is the file full path
 */
+(void) writeStringsFile: (NSDictionary*)outterContents {
    NSArray* fliePaths = [outterContents allKeys];
    for (NSString* filePath in fliePaths) {
        NSDictionary* contents = [outterContents objectForKey: filePath];
        [LocalizeFileManager writeStringsFile: contents toPath:filePath];
    }
}

/** @prama contents one dimensioin dictionary */
+(void) writeStringsFile: (NSDictionary*)contents toPath:(NSString*)filePath {
    NSError* error = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    BOOL existed = [manager fileExistsAtPath: filePath];
    if (existed) {
        [manager removeItemAtPath: filePath error: &error];
    }
    
    BOOL created = [manager createFileAtPath: filePath contents: nil attributes: nil];
    
    if (created) {
        NSMutableString* stringsFileContents = [[NSMutableString alloc] init];
        
        // sorted keys
        NSArray* sortedKeys = [[contents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        // append keys-values
        for (int i = 0; i < sortedKeys.count ; i ++) {
            id key = [sortedKeys objectAtIndex: i];
            NSString* value = [contents objectForKey: key];
            NSString* keyValue = [NSString stringWithFormat: @"\"%@\"=\"%@\";\r\n", key , value];
            [stringsFileContents appendString: keyValue];
        }
        
        // write to file
        [stringsFileContents writeToFile: filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    }
}


/** @return outterContents two dimensioin dictionary
 
 outter keys is the file full path
 */
+(NSMutableDictionary*) readStringsFiles: (NSArray*)filePaths {
    NSMutableDictionary* outterContents = [[NSMutableDictionary alloc] initWithCapacity: 0];
    for( int i = 0; i < filePaths.count; i++){
        NSString* filePath = [filePaths objectAtIndex: i];
        NSMutableDictionary* contents = [self readStringsFile: filePath];
        [outterContents setObject:contents forKey:filePath];
    }
    return outterContents;
}

/** @return the file content */
+(NSMutableDictionary*) readStringsFile: (NSString*)filePath {
    NSPropertyListFormat format ;
    NSData *plistData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSDictionary *contents = [NSPropertyListSerialization propertyListWithData: plistData options:NSPropertyListImmutable format:&format error:&error];

    return [NSMutableDictionary dictionaryWithDictionary: contents];
}

@end
