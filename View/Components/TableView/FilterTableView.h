#import "TableViewBase.h"

typedef enum : NSUInteger {
    FilterModeContains  = 0,
    FilterModeBeginWith = 1 << 0,
    FilterModeEndWith   = 2 << 1,
} FilterMode;

@interface FilterTableView : TableViewBase

@property (assign) BOOL disable;
@property (strong, nonatomic) NSString* filterText;
@property (assign, nonatomic) FilterMode filterMode;

@property (strong) NSMutableDictionary* backContentsDictionary;

-(BOOL) isInFilteringMode;

-(NSIndexPath*) getRealIndexPathBySubView:(UIView*)subview ;

-(NSIndexPath*) getRealIndexPathInFilterMode: (NSIndexPath*)visualIndexPath;




@end
