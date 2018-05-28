#import <Foundation/Foundation.h>


@class NSManagedObjectModel;
@class NSManagedObjectContext;
@class NSPersistentStoreCoordinator;

@interface CoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectModel* manageObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext* manageObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end
