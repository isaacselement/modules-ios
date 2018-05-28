#import <UIKit/UIKit.h>

@class AlignTableView;
@class HeaderTableView;


@protocol HeaderTableViewDeletage <NSObject>

@optional
-(CGFloat) headerTableViewGap: (HeaderTableView*)view;
-(CGFloat) headerTableViewHeaderHeight: (HeaderTableView*)view;

@end


@interface HeaderTableView : UIView

@property (strong) UIView* headerView;
@property (assign) Class headerLabelClass;
@property (strong) AlignTableView* tableView;
@property (nonatomic, assign) id<HeaderTableViewDeletage> headerDelegate;


@property (nonatomic, strong) NSArray* headers;            //here one dimension

@property (nonatomic, strong) NSArray* headersXcoordinates;//here one dimension
@property (nonatomic, strong) NSArray* valuesXcoordinates; //here one dimension
@property (nonatomic, strong) NSArray* headersYcoordinates;//here one dimension
@property (nonatomic, strong) NSArray* valuesYcoordinates; //here one dimension

#pragma mark - Public Methods
-(void) restoreConstraints;
-(void) reloadTableData ;           // reload table view data



#pragma mark - Subclass Override Methods
-(void) initializeSubviews;
-(void) initializeSubviewsHConstraints;
-(void) initializeSubviewsVConstraints;



#pragma mark - Class Methods
+(float) getHeaderTableGap: (HeaderTableView*)headerTableView;
+(float) getHeaderViewHeight: (HeaderTableView*)headerTableView;

@end







//_______________________________________________________________________________________________________________

@interface HeaderTableView (ActionBlock)

@property (copy) CGFloat(^headerTableViewGapAction)(HeaderTableView* view);
@property (copy) CGFloat(^headerTableViewHeaderHeightAction)(HeaderTableView* view);

@end