#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SQLiteManager : NSObject

-(sqlite3*) sqlite3;

-(BOOL) openDatabase: (const char*)sqlite3FilePath;



-(BOOL) executeSQL: (const char*)sqlString;

-(void) executeSelectSQL: (const char*)sqlString handle:(void(^)(sqlite3_stmt* statement))handler;

-(BOOL) executeUpdateInsertSQL:(const char *)sqlString handle:(void(^)(sqlite3_stmt* statement))handler;

@end
