#import <Foundation/Foundation.h>

@interface DropboxSyncUploader : NSObject

+(BOOL) upload: (NSString*)dropboxPath localPath:(NSString*)localFilePath ;

@end
