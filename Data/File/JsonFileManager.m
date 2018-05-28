#import "JsonFileManager.h"

#define JSON_EXTENTION @"json"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif



@implementation JsonFileManager

/** @return Could be NSDictionary or NSArray */
+(id) getJsonFromFile: (NSString*)jsonFileName
{
    jsonFileName = [[jsonFileName pathExtension] length] == 0 ? [jsonFileName stringByAppendingPathExtension: JSON_EXTENTION] : jsonFileName;
    NSString* jsonFilePath = BUNDLEFILE_PATH(jsonFileName);
    return [JsonFileManager getJsonFromPath: jsonFilePath];
}


+(id) getJsonFromPath: (NSString*)jsonFilePath
{
    NSData* jsonData = [NSData dataWithContentsOfFile: jsonFilePath];
    
    if (! jsonData) return nil;
    
    NSError* error = nil;
    id content = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingAllowFragments error:&error];
    
#ifdef DEBUG
    if (error) {
        NSLog(@"Json File Format Error, Check it out !!! %@", jsonFilePath);
    }
    
    if (error) {
        NSString* message = [NSString stringWithFormat:@"Check your %@ json file or json format please", [jsonFilePath lastPathComponent]];
#if TARGET_OS_IPHONE
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"JASON PARSE ERROR"
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
#else
        NSRunAlertPanel(@"JASON PARSE ERROR", message, @"OK", nil, nil);
#endif
        
    }
#endif
    return content;

}

@end
