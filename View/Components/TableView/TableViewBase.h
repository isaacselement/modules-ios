#import <UIKit/UIKit.h>


@class TableViewBase;


//_______________________________________________________________________________________________________________

@protocol TableViewBaseTableProxy <NSObject>

@optional

// UITableViewDataSource
- (NSInteger) tableViewBaseNumberOfSections:(TableViewBase *)tableViewObj;
- (NSInteger) tableViewBaseNumberOfRows: (TableViewBase *)tableViewObj inSection:(NSInteger)section;

- (UITableViewCell*)tableViewBase:(TableViewBase *)tableViewObj cellForIndexPath:(NSIndexPath *)indexPath oldCell:(UITableViewCell*)oldCell;


// Edit Pair Extendions ("Delete default"):
- (BOOL)tableViewBase:(TableViewBase *)tableViewObj canEditIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj commitEditStyle:(UITableViewCellEditingStyle)editStyle indexPath:(NSIndexPath *)indexPath;

- (BOOL)tableViewBase:(TableViewBase *)tableViewObj shouldDeleteContentsAtIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj didDeleteContentsAtIndexPath:(NSIndexPath*)indexPath;



// UITableViewDelegate
- (void)tableViewBase:(TableViewBase *)tableViewObj didSelectIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj willShowCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath;

- (CGFloat)tableViewBase:(TableViewBase *)tableViewObj heightForSection:(NSInteger)section;

- (CGFloat)tableViewBase:(TableViewBase *)tableViewObj heightForIndexPath:(NSIndexPath*)indexPath;


// Edit Pair Extendions :
- (NSString*)tableViewBase:(TableViewBase *)tableViewObj titleForDeleteButtonAtIndexPath:(NSIndexPath*)indexPath;

@end


//_______________________________________________________________________________________________________________

@protocol TableViewBaseScrollProxy <NSObject>

@optional

// UIScrollViewDelegate
- (void)tableViewBaseDidScroll:(TableViewBase *)tableViewObj ;

- (void)tableViewBase:(TableViewBase *)tableViewObj didEndDragging:(BOOL)willDecelerate;

- (void)tableViewBaseDidEndDecelerating:(TableViewBase *)tableViewObj;

@end





//_______________________________________________________________________________________________________________

@interface TableViewBase : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(assign) BOOL hideSections;

@property(assign) id<TableViewBaseTableProxy> proxy;
@property(assign) id<TableViewBaseScrollProxy> scrollProxy;     // For RefreshTableView now

-(NSString *)cellReuseIdentifier;

// "_l" for "_local"

// if keysMap == nil , asume that the keys is the same!!!!
// @{@"section_1_l" : @"section_1", @"section_2_l":@"section_2" }
@property(strong) NSMutableDictionary* keysMap;

// { @"section_1":@[@"1",,@"2",@"3"], @"section_2":@[@"1",@"2",@"3"] };
// the background/real data of contentsDictionary, be sure has the same sort/order/sequence contentsDictionary
@property (strong) NSMutableDictionary* realContentsDictionary;

// { @"section_1_l":@[@"1_l",@"2_l",@"3_l"], @"section_2_l":@[@"1_l",@"2_l",@"3_l] };
// the show/visible contents to end-user, be sure has the same sort/order/sequence realContentsDictionary
@property(strong, nonatomic) NSMutableDictionary* contentsDictionary;



/** get the sequential keys of contentsDictionary, against to the table section */
-(NSArray *)sections;

/** the visible content by indexPath */
-(id) contentForIndexPath: (NSIndexPath*)indexPath;

/** get the realValue By indexPath */
-(id) realContentForIndexPath: (NSIndexPath*)indexPath;

-(NSMutableArray*) contentsForSection: (NSUInteger)section;
-(NSMutableArray*) realContentsForSection: (NSUInteger)section;


#pragma mark - Protect Util Methods (For FilterTableView Override Now)

-(void) deleteIndexPathWithAnimation: (NSIndexPath*)indexPath;


@end





//_______________________________________________________________________________________________________________


@interface TableViewBase (ActionBlock)

// To Be Extended ...

// UITableViewDataSource
@property (copy) NSInteger(^tableViewBaseNumberOfSectionsAction)(TableViewBase* tableViewObj);
@property (copy) NSInteger(^tableViewBaseNumberOfRowsInSectionAction)(TableViewBase* tableViewObj, NSInteger section);
@property (copy) UITableViewCell* (^tableViewBaseCellForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath, UITableViewCell* oldCell);
@property (copy) BOOL (^tableViewBaseCanEditIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseCommitEditStyleAction)(TableViewBase* tableViewObj, UITableViewCellEditingStyle editStyle, NSIndexPath* indexPath);


@property (copy) BOOL (^tableViewBaseShouldDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseDidDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);

// UITableViewDelegate
@property (copy) void (^tableViewBaseWillShowCellAction)(TableViewBase* tableViewObj,UITableViewCell* cell, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseDidSelectIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) CGFloat(^tableViewBaseHeightForSectionAction)(TableViewBase* tableViewObj, NSInteger section);
@property (copy) CGFloat(^tableViewBaseHeightForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) NSString*(^tableViewBaseTitleForDeleteButtonAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);

@end


