#import <Foundation/Foundation.h>

@interface FileManager : NSObject {
}

#pragma mark - Path
// in the last path string do not have "/"
/* Use [NSString stringByAppendingPathComponent:], you really no need to care about this*/
+(NSString*) tempPath ;
+(NSString*) homePath ;
+(NSString*) documentsPath ;

+(NSString*) libraryPath ;
+(NSString*) libraryCachesPath ;
+(NSString*) libraryPreferencesPath ;





#pragma mark - Delete , Copy , Move , Create and Write , Check Exist ...

+(NSError*) deleteFile: (NSString*)fullPath ;
+(NSError*) copyFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath ;
+(NSError*) moveFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath ;

+(BOOL) writeDataToFile: (NSString*)fullPath data:(NSData*)data;

+(BOOL) appendDataToFile: (NSString*)fullPath data:(NSData*)data;


+(BOOL) isFileExist: (NSString*)fullPath ;

+(BOOL) createFileWhileNotExist: (NSString*)fullPath ;

+(BOOL) createFolderWhileNotExist: (NSString*)fullPath;




#pragma mark -

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath ;
+(NSArray*) getFileNamesIn:(NSString*)directoryPath;




#pragma mark - Not backed up to iCloud Methods

+(void) addSkipBackupAttributeToPath:(NSString*)path;
+(BOOL) addSkipBackupAttributeToItemAtURL:(NSURL*)URL;




    
@end
