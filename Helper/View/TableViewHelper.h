#import <UIKit/UIKit.h>

@interface TableViewHelper : NSObject

+(NSIndexPath*) getIndexPathByCellSubView:(UIView*)subView;


// get cell by cell's subview
+(UITableViewCell*) getTableViewCellBySubView:(UIView*)subview;



+(UITableView*) getTableViewBySubView: (UIView*)subView;



@end
