#import "FileManager.h"
#include <sys/xattr.h>  // for addSkipBackupAttributeToItemAtURL: method

#define NSFileManagerInstance [NSFileManager defaultManager]        // no delegate here

#define Library @"Library"

#define LibraryCaches @"Caches"

#define LibraryPreferences @"Preferences"


@implementation FileManager

#pragma mark - Path

+(NSString*) tempPath {
    return NSTemporaryDirectory();
}

+(NSString*) homePath {
    return NSHomeDirectory();
}

+(NSString*) documentsPath {
    NSArray* documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    return [documentsPaths firstObject];
}

+(NSString*) libraryPath {
    return [[self homePath] stringByAppendingPathComponent: Library];
}

+(NSString*) libraryCachesPath {
    return [[self libraryPath] stringByAppendingPathComponent: LibraryCaches];
}

+(NSString*) libraryPreferencesPath {
    return [[self libraryPath] stringByAppendingPathComponent: LibraryPreferences];
}





#pragma mark - Delete, Copy, Save, Move , Create , Check Exist ...

// full path can be a file or directory
+(NSError*) deleteFile: (NSString*)fullPath {
    NSError* error = nil;
    [NSFileManagerInstance removeItemAtPath: fullPath error:&error];
    return error;
}

+(NSError*) copyFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath {
    [self createFolderWhileNotExist: fileDesFullPath];
    NSError* error = nil;
    [NSFileManagerInstance copyItemAtPath: fileSrcFullPath toPath:fileDesFullPath error:&error];
    return error;
}

+(NSError*) moveFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath {
    [self createFolderWhileNotExist: fileDesFullPath];
    NSError* error = nil;
    [NSFileManagerInstance moveItemAtPath:fileSrcFullPath toPath:fileDesFullPath error:&error];
    return error;
}

+(BOOL) writeDataToFile: (NSString*)fullPath data:(NSData*)data {
    [self createFolderWhileNotExist: fullPath];
    return [NSFileManagerInstance createFileAtPath:fullPath contents:data attributes:nil];   // it will create a file or overwrites it
//    return [data writeToFile: fullPath atomically:NO];        // wrong , it will not create a file if the full path file not exists
}

+(BOOL) appendDataToFile: (NSString*)fullPath data:(NSData*)data {
    if ([FileManager isFileExist: fullPath]) {
        NSFileHandle* fileHandler = [NSFileHandle fileHandleForWritingAtPath: fullPath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData: data];
        [fileHandler closeFile];
        return YES;
    } else {
        return [FileManager writeDataToFile: fullPath data:data];
    }
}



+(BOOL) isFileExist: (NSString*)fullPath {
    return ([NSFileManagerInstance fileExistsAtPath:fullPath]);
}

+(BOOL) createFileWhileNotExist: (NSString*)fullPath {
    BOOL isSuccessfully = YES;
    if (![self isFileExist: fullPath]) {
        return [self writeDataToFile: fullPath data:[NSData data]];
    }
    return isSuccessfully;
}

+(BOOL) createFolderWhileNotExist: (NSString*)fullPath {
    BOOL isSuccessfully = YES;
    
    if(! [self isFileExist: fullPath]) {
        // file not exists
        NSString* directoryPath = [fullPath stringByDeletingLastPathComponent];
        if(! [self isFileExist: directoryPath]) {
            NSError* error = nil;
            // dir not exists, create it
            isSuccessfully = [NSFileManagerInstance createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
#ifdef DEBUG
            if(error){
                NSLog(@"Error! NSFileManager createFolderWhileNotExist: Failed when create %@ ", fullPath);
            }
#endif
        }
    }
    
    
    return isSuccessfully;
}



#pragma mark - 

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath
{
    NSArray *files = [self getFileNamesIn:directoryPath];
    if (! files) return nil;
    
    NSMutableArray* filePaths = [NSMutableArray array];
    for (NSString* file in files) {
        NSString* path = [directoryPath stringByAppendingPathComponent: file];
        if (path) [filePaths addObject: path];
    }
    
    return filePaths;
}


+(NSArray*) getFileNamesIn: (NSString*)directoryPath
{
    NSError* error = nil;
    NSArray* files = [NSFileManagerInstance contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error != nil){
#ifdef DEBUG
        NSLog(@"Error! NSFileManager getFileNamesIn:\n %@", error);
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return nil;
    }
    
    return files;
}




#pragma mark - Not backed up to iCloud Methods
// Do not backed up to iCloud , iOS 5.0.1 and above
+(void) addSkipBackupAttributeToPath:(NSString*)path
{
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

+(BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}





@end
