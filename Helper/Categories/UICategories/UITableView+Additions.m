#import "UITableView+Additions.h"

@implementation UITableView (Additions)

#pragma mark - About IndexPath

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    return indexPath.section == lastIndexPath.section && indexPath.row == lastIndexPath.row ;
}

- (NSIndexPath * _Nonnull)lastIndexPath {
    NSInteger lastSection = self.numberOfSections - 1;
    return [self lastIndexPathInSection:lastSection];
}

- (NSIndexPath * _Nonnull)lastIndexPathInSection:(NSUInteger)section {
    NSInteger lastRow = [self numberOfRowsInSection: section] - 1;
    return [NSIndexPath indexPathForRow: lastRow inSection:section];
}

- (BOOL)isLastSection:(NSInteger)section {
    return section == [self lastSection];
}

- (NSUInteger)lastSection {
    return  self.numberOfSections - 1;
}

- (NSIndexPath * _Nullable)indexPathForView:(UIView * _Nullable)subView
{
    UIView* superview = subView.superview;
    while (superview && ![superview isKindOfClass:[UITableViewCell class]]) {
        superview = superview.superview;
    }
    return [self indexPathForCell: (UITableViewCell *)superview];
}

+ (NSMutableArray * _Nonnull)indexPathsFromRow:(NSInteger)row section:(NSInteger)section count:(NSInteger)count {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = row; i < row + count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    return indexPaths;
}

#pragma mark - Add, Insert & Delete

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath rowsDataSource:(NSMutableArray *)rowsDataSource {
    [self updateTableDataSourceWithAnimation:^{
        [rowsDataSource removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
}

- (void)insertRowsAtIndexPath:(NSIndexPath *)indexPath with:(NSArray *)inserts rowsDataSource:(NSMutableArray *)rowsDataSource {
    [self updateTableDataSourceWithAnimation:^{
        [rowsDataSource insertObjects:inserts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, inserts.count)]];
        NSMutableArray *insertsIndexPaths = [UITableView indexPathsFromRow:indexPath.row section:indexPath.section count:inserts.count];
        [self insertRowsAtIndexPaths:insertsIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    }];
}

- (void)replaceRowAtIndexPath:(NSIndexPath *)indexPath with:(NSArray *)replaces rowsDataSource:(NSMutableArray *)rowsDataSource {
    NSMutableArray *details = [NSMutableArray arrayWithArray:replaces];
    [rowsDataSource replaceObjectAtIndex:indexPath.row withObject:[details firstObject]];
    if (details.count > 1) { // do insert job in additions
        [details removeObjectAtIndex:0];
        NSArray *inserts = details;
        [rowsDataSource insertObjects:inserts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, inserts.count)]];
    }
    [self reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

// reload table immediately after delete animation, would break the animation. forbid user all request in the meantime.
- (void)updateTableDataSourceWithAnimation:(void (^)())updateAction {
    self.window.userInteractionEnabled = NO;
    [self beginUpdates];
    updateAction();
    [self endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
        self.window.userInteractionEnabled = YES;
    });
}


@end
