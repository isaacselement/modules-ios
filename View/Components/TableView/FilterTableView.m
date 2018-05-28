#import "FilterTableView.h"
#import "NSArray+Additions.h"
#import "TableViewHelper.h"


@implementation FilterTableView

@synthesize backContentsDictionary;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.filterMode = FilterModeContains;
    }
    return self;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    super.contentsDictionary = contentsDictionary;
    backContentsDictionary = contentsDictionary;
}

-(void)setFilterText:(NSString *)filterText
{
    _filterText = filterText;
    
    [self updateVisualContentsWithFilterText];
    [super reloadData];
}

-(void) updateVisualContentsWithFilterText
{
    // is In Filter Mode
    if ([self isInFilteringMode]) {
        NSMutableDictionary* searchContentsDictionary = [NSMutableDictionary dictionary];
        
        for (NSString* key in backContentsDictionary) {
            NSArray* contents = [backContentsDictionary objectForKey: key];
            NSMutableArray* results = [NSMutableArray array];
            
            for (int i = 0; i < contents.count; i++) {
                id value = [contents objectAtIndex: i];
                
                NSString* string = [self getValueAsString: value];
                BOOL isMeet = [self isMeet: string];
                if (isMeet) {
                    [results addObject: value];
                }
            }
            
            if (results.count) {
                [searchContentsDictionary setObject: results forKey:key];
            } else {
                [searchContentsDictionary removeObjectForKey: key];
            }
        }
        super.contentsDictionary = searchContentsDictionary;
        
        // Normal Mode
    } else {
        super.contentsDictionary = backContentsDictionary;
    }
}

-(NSString*) getValueAsString: (id)value
{
    NSString* string = nil;
    // string
    if ([value isKindOfClass:[NSString class]]) {
        string = value;
    // array
    } else if ([value isKindOfClass:[NSArray class]]) {
        string = [value componentsJoinedByString:@" "];
    }
    return string;
}

-(BOOL) isMeet: (NSString*)string
{
    FilterMode mode = self.filterMode;
    NSString* filterText = self.filterText;
    
    if (mode == FilterModeContains) {
        return [string rangeOfString: filterText options:NSCaseInsensitiveSearch].location != NSNotFound;
    } else {
        BOOL isBingo = NO;
        if ((mode & FilterModeBeginWith) == FilterModeBeginWith) {
            isBingo = isBingo || [string hasPrefix: self.filterText];
        }
        if ((mode & FilterModeEndWith) == FilterModeEndWith) {
            isBingo = isBingo || [string hasSuffix: self.filterText];
        }
        return isBingo;
    }
}

#pragma mark - Override Super Methods
-(void)reloadData
{
    [self updateVisualContentsWithFilterText];
    [super reloadData];
}

-(void) deleteIndexPathWithAnimation: (NSIndexPath*)indexPath
{
    // when not in filter mode , contentsDictionary == backContentsDictionary
    if ([self isInFilteringMode]) {
        
        NSString* sectionTitle = [self.sections safeObjectAtIndex: indexPath.section];
        
        // this should go first , then do the remove job
        NSIndexPath* realIndexPath = [self getRealIndexPathInFilterMode: indexPath];
        
        // A . delete the contents dictionary row data
        NSMutableArray* sectionContents = [self.contentsDictionary objectForKey: sectionTitle];
        [sectionContents removeObjectAtIndex: indexPath.row];
        
        // B . delete the back up contents diectionary row data
        NSMutableArray* backSectionContents = [self.backContentsDictionary objectForKey: sectionTitle];
        [backSectionContents removeObjectAtIndex: realIndexPath.row];
        
        // C . delete the real contents dictionary row data
        NSMutableArray* realSectionContents = [self realContentsForSection: realIndexPath.section];
        [realSectionContents removeObjectAtIndex: realIndexPath.row];
        
        // D . apply the animation, be sure your data source updated before call this method
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        [super deleteIndexPathWithAnimation: indexPath];
    }

}

#pragma mark - Public Methods

-(BOOL) isInFilteringMode
{
    return self.filterText != nil && ![self.filterText isEqualToString:@""] && !self.disable;
}

// get the real index path by view in cell
-(NSIndexPath*) getRealIndexPathBySubView:(UIView*)subview 
{
    // get table cell & get the index path
    UITableViewCell* cell = [TableViewHelper getTableViewCellBySubView:subview];
    NSIndexPath* indexPath = [self indexPathForCell: cell];
    if ([self isInFilteringMode]) {
        indexPath = [self getRealIndexPathInFilterMode:indexPath];
    }
    return indexPath;
}

-(NSIndexPath*) getRealIndexPathInFilterMode: (NSIndexPath*)visualIndexPath
{
    if ([self isInFilteringMode]) {
        
        id value = [super contentForIndexPath: visualIndexPath];
        
        for (NSInteger section = 0 ; section < self.numberOfSections; section++ ){
            NSString* sectionKey = [self.sections objectAtIndex: section];
            NSArray* sectionContents = [backContentsDictionary objectForKey: sectionKey];
            NSUInteger row = [sectionContents indexOfObject: value];
            if (row != NSNotFound) {
                return [NSIndexPath indexPathForRow: row inSection:section];
            }
        }
        
        NSLog(@"getRealIndexPathInFilterMode: Error!!!!!");
        return [NSIndexPath indexPathForRow: -1 inSection:-1];
        
    } else {
        
        return visualIndexPath;
        
    }
    
}

@end
