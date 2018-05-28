#import <UIKit/UIKit.h>

@interface UITableView (Additions)

#pragma mark - About IndexPath

- (BOOL)isLastIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (NSIndexPath * _Nonnull)lastIndexPath;

- (NSIndexPath * _Nonnull)lastIndexPathInSection:(NSUInteger)section;

- (BOOL)isLastSection:(NSInteger)section ;

- (NSUInteger)lastSection;

- (NSIndexPath * _Nullable)indexPathForView:(UIView * _Nullable)subView;

+ (NSMutableArray * _Nonnull)indexPathsFromRow:(NSInteger)row section:(NSInteger)section count:(NSInteger)count ;

#pragma mark - Add, Insert & Delete

- (void)deleteRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath rowsDataSource:(NSMutableArray * _Nonnull)rowsDataSource ;

- (void)insertRowsAtIndexPath:(NSIndexPath * _Nonnull)indexPath with:(NSArray * _Nonnull)inserts rowsDataSource:(NSMutableArray * _Nonnull)rowsDataSource ;

- (void)replaceRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath with:(NSArray * _Nonnull)replaces rowsDataSource:(NSMutableArray * _Nonnull)rowsDataSource ;

- (void)updateTableDataSourceWithAnimation:(void (^ _Nullable)())updateAction ;

@end
