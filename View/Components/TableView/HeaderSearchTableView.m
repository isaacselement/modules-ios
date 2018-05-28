#import "HeaderSearchTableView.h"
#import "AlignTableView.h"
#import "SearchBarView.h"

#import "FrameTranslater.h"

@implementation HeaderSearchTableView

@synthesize searchBar;

@synthesize searchBarHeight = _searchBarHeight;

-(void)setHideSearchBar:(BOOL)hideSearchBar
{
    _hideSearchBar = hideSearchBar;
    
    if (hideSearchBar) {
        searchBar.hidden = YES;
        [searchBar removeFromSuperview];
        [self removeConstraints: self.constraints];
        [super initializeSubviewsHConstraints];
        [super initializeSubviewsVConstraints];
    } else {
        searchBar.hidden = NO;
        [self addSubview: searchBar];
        [self removeConstraints: self.constraints];
        [self initializeSubviewsHConstraints];
        [self initializeSubviewsVConstraints];
    }
}

-(void)setSearchBarHeight:(CGFloat)searchBarHeightValue
{
    _searchBarHeight = searchBarHeightValue;
    
    [self restoreConstraints];
}

-(CGFloat)searchBarHeight
{
   return _searchBarHeight == 0 ? CanvasH(45) : _searchBarHeight;
}


#pragma mark - Override Super Methods
-(void) initializeSubviews
{
    [super initializeSubviews];
    
    searchBar = [[SearchBarView alloc] init];
    searchBar.delegate = self;
    searchBar.textField.placeholder = @"Search";
    [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview: searchBar];
}

-(void)initializeSubviewsHConstraints
{
    [super initializeSubviewsHConstraints];
    
    if ([self.subviews containsObject: searchBar]) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"|-0-[searchBar]-0-|"
                              options:NSLayoutFormatAlignAllBaseline
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(searchBar)]];
    }
}

-(void) initializeSubviewsVConstraints
{
    if ([self.subviews containsObject: searchBar]) {
        UIView* headerView = super.headerView;
        UITableView* tableView = super.tableView;
        float gap = [HeaderTableView getHeaderTableGap: self];
        float headerHeight = [HeaderTableView getHeaderViewHeight: self];
        float searchBarHeight = self.searchBarHeight;
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|-0-[searchBar(searchBarHeight)][headerView(headerHeight)]-(gap)-[tableView]-0-|"
                              options:NSLayoutFormatDirectionLeadingToTrailing
                              metrics:@{@"searchBarHeight":@(searchBarHeight), @"headerHeight":@(headerHeight), @"gap":@(gap)}
                              views:NSDictionaryOfVariableBindings(searchBar,headerView,tableView)]];
    } else {
        [super initializeSubviewsVConstraints];
    }
    
}


#pragma mark - SearchBarViewDelegate Methods
- (void)searchBarView:(SearchBarView *)searchBar textDidChange:(NSString *)searchText
{
    super.tableView.filterText = searchText;
}
- (void)searchBarViewCancelButtonClicked:(SearchBarView *) searchBar
{
    super.tableView.filterText = nil;
    self.searchBar.textField.text = nil;
    [self.searchBar.textField resignFirstResponder];
}
- (void)searchBarViewSearchButtonClicked:(SearchBarView *)searchBar
{
    [self.searchBar.textField resignFirstResponder];
}


@end
