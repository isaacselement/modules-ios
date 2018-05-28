#import "DropboxSyncUploader.h"

#import "DropboxSyncAPIManager.h"
#import <Dropbox/Dropbox.h>

@implementation DropboxSyncUploader


/** @para dropboxPath is the path in your dropbox, with file name
   @para localFilePath is the path of your local file, with file name
 
 @return YES for successfully , NO for failed
 */
+(BOOL) upload: (NSString*)dropboxPath localPath:(NSString*)localFilePath {
    
    DBPath* rootPath = [DropboxSyncAPIManager getRootPath];
    DBPath* childrenPath = [rootPath childPath: dropboxPath];
    DBFilesystem* fileSystem = [DropboxSyncAPIManager getFilesystem];
    
    NSError* error = nil;
    DBFileInfo* fileInfo = [fileSystem fileInfoForPath: childrenPath error:&error];
    NSLog(@"error 0 %@", error);
    if (fileInfo) {
        error = nil;
        [fileSystem deletePath:childrenPath error:&error];
        NSLog(@"error 1 %@", error);
    }
    
    
    NSError* createError = nil;
    DBFile* file = [fileSystem createFile: childrenPath error:&createError];
    NSLog(@"createError 1 %@", createError);
    
    NSError* writeError = nil;
    [file writeContentsOfFile:localFilePath shouldSteal:NO error:&writeError];
    NSLog(@"writeError 2 %@", writeError);
    
    NSLog(@"Export to Drobox: %@", childrenPath);
    
    if (createError || writeError) return NO;
    return YES;
}

@end
