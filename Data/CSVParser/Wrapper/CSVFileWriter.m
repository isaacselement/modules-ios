#import "CSVFileWriter.h"

#import "CHCSVParser.h"
#import "FileManager.h"

#define CSVDelimiter ','

@implementation CSVFileWriter


/** two dimension , per array per line, headerFields in the first line */
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields {
    [self write:array to:fullPath headerFields:headerFields append:NO];
}

/**
 *  @prama  arry is one or two dimensions , e.g.
 @[
 @[@"one",@"two"],
 @[@"A",@"B"]
 ]
 *
 *   @prama fullPath with the filename , e.g. path = "/Document/CVS/content.csv"
 */
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields append:(BOOL)append {
    [FileManager createFolderWhileNotExist: fullPath];
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:fullPath append:append];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:CSVDelimiter];
    
    // write headers
    if (headerFields) [writer writeLineOfFields:headerFields];
    
    BOOL isTowDimensions = [[array lastObject] isKindOfClass:[NSArray class]];
    
    // write contents
    if (isTowDimensions) {
        for (NSArray* line in array) [writer writeLineOfFields:line];
    } else {
        [writer writeLineOfFields:array];
    }
    
    [writer closeStream];
}



@end
