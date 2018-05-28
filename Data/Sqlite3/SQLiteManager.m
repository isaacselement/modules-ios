#import "SQLiteManager.h"


@implementation SQLiteManager
{
    sqlite3* sqlite3Instance;
}

-(sqlite3*) sqlite3
{
    return sqlite3Instance;
}

-(BOOL) openDatabase: (const char*)sqlite3FilePath
{
    sqlite3_close(sqlite3Instance);
    
    BOOL status = sqlite3_open(sqlite3FilePath, &sqlite3Instance) == SQLITE_OK ;
    
    if (!status) {
        sqlite3_close(sqlite3Instance);
    }
    
    return status;
}





// i.e. "create table if not exists persons (id integer primary key autoincrement,name text)"
// i.e. "DELETE FROM persons WHERE id = 24"
-(BOOL) executeSQL: (const char*)sqlString
{
    char* error;
    BOOL status = sqlite3_exec(sqlite3Instance, sqlString, NULL, NULL, &error) == SQLITE_OK;
    return status;
}


// select last result : SELECT * FROM User WHERE ID = (SELECT MAX(ID) FROM User)
// i.e. "select id, name from persons"
-(void) executeSelectSQL: (const char*)sqlString handle:(void(^)(sqlite3_stmt* statement))handler
{
    sqlite3_stmt* statement;
    int status = sqlite3_prepare_v2(sqlite3Instance, sqlString, -1, &statement, nil);
    
    if (status == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            // i.e.
//            int _id = sqlite3_column_int(statement, 0);
//            const unsigned char* _name = sqlite3_column_text(statement, 1);
            
            handler(statement);
        }
        
    }
    
    sqlite3_finalize(statement);
}

// i.e "update User set password = (?) WHERE id = (SELECT MIN(id) FROM User)"
-(BOOL) executeUpdateInsertSQL:(const char *)sqlString handle:(void(^)(sqlite3_stmt* statement))handler
{
    sqlite3_stmt* statement;
    int status = sqlite3_prepare_v2(sqlite3Instance, sqlString, -1, &statement, nil);
    
    if (status == SQLITE_OK) {
//        sqlite3_bind_text(stmt, 1, "passwordValue", -1, NULL);
        handler(statement);
    }
    
    BOOL isOk = sqlite3_step(statement) == SQLITE_DONE;
    
    sqlite3_finalize(statement);
    
    return isOk;
}


@end
