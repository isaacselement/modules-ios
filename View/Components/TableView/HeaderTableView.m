#import "HeaderTableView.h"
#import "AlignTableView.h"

// _View.h
#import "FrameTranslater.h"



@interface HeaderTableView ()
{
    CGFloat(^_headerTableViewGapAction)(HeaderTableView* view);
    CGFloat(^_headerTableViewHeaderHeightAction)(HeaderTableView* view);
}

@end



@implementation HeaderTableView

@synthesize tableView;
@synthesize headerView;
@synthesize headerDelegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
        [self restoreConstraints];
    }
    return self;
}

-(void)setHeaders:(NSArray *)headers
{
    tableView.headers = headers;
    [AlignTableView setAlignHeaders: self.headerLabelClass headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void) setHeadersXcoordinates:(NSArray *)headersXcoordinates
{
    tableView.headersXcoordinates = headersXcoordinates;
    [AlignTableView setAlignHeaders: self.headerLabelClass headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void) setHeadersYcoordinates:(NSArray *)headersYcoordinates
{
    tableView.headersYcoordinates = headersYcoordinates;
    [AlignTableView setAlignHeaders: self.headerLabelClass headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void)setValuesXcoordinates:(NSArray *)valuesXcoordinates
{
    tableView.valuesXcoordinates = valuesXcoordinates;
}

-(void) setValuesYcoordinates:(NSArray *)valuesYcoordinates
{
    tableView.valuesYcoordinates = valuesYcoordinates;
}

-(void)setHeaderDelegate:(id<HeaderTableViewDeletage>)headerDelegateObj
{
    headerDelegate = headerDelegateObj;
    // reset it
    [self restoreConstraints];
    // refresh
    [self setNeedsLayout];
}

#pragma mark - Public Methods
-(void) restoreConstraints
{
    [self removeConstraints: self.constraints];
    [self initializeSubviewsHConstraints];
    [self initializeSubviewsVConstraints];
}

-(void) reloadTableData {
    [tableView reloadData];
}

#pragma mark - Subclass Override Methods

-(void) initializeSubviews
{
    headerView = [[UIView alloc] init];
    tableView = [[AlignTableView alloc] init];
    
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    [self addSubview: tableView];
    [self addSubview: headerView];
}

-(void) initializeSubviewsHConstraints
{
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-0-[headerView]-0-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(headerView)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-0-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(tableView)]];
}

-(void) initializeSubviewsVConstraints
{
    float gap = [HeaderTableView getHeaderTableGap: self];
    float headerHeight = [HeaderTableView getHeaderViewHeight: self];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[headerView(headerHeight)]-(gap)-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"headerHeight":@(headerHeight),@"gap":@(gap)}
                          views:NSDictionaryOfVariableBindings(headerView,tableView)]];
    
}


#pragma mark - Class Methods
+(float) getHeaderTableGap: (HeaderTableView*)headerTableView
{
    float gap = [FrameTranslater convertCanvasHeight: 0.0f];
    
    if (headerTableView.headerTableViewGapAction) {
        gap = headerTableView.headerTableViewGapAction(headerTableView);
    }
    else if (headerTableView.headerDelegate && [headerTableView.headerDelegate respondsToSelector:@selector(headerTableViewGap:)]) {
        gap = [headerTableView.headerDelegate headerTableViewGap: headerTableView];
    }
    return gap;
}

+(float) getHeaderViewHeight: (HeaderTableView*)headerTableView
{
    float headerHeight = CanvasH(30);
    if (headerTableView.headerTableViewHeaderHeightAction) {
        headerHeight = headerTableView.headerTableViewHeaderHeightAction(headerTableView);
    } else if (headerTableView.headerDelegate && [headerTableView.headerDelegate respondsToSelector:@selector(headerTableViewHeaderHeight:)]) {
        headerHeight = [headerTableView.headerDelegate headerTableViewHeaderHeight:headerTableView];
    }
    return headerHeight;
}

@end









//_______________________________________________________________________________________________________________

@implementation HeaderTableView (ActionBlock)

-(CGFloat (^)(HeaderTableView *))headerTableViewGapAction
{
    return _headerTableViewGapAction;
}
-(void)setHeaderTableViewGapAction:(CGFloat (^)(HeaderTableView *))headerTableViewGapAction
{
    _headerTableViewGapAction = headerTableViewGapAction;
    
    // reset it
    [self restoreConstraints];
}


-(CGFloat (^)(HeaderTableView *))headerTableViewHeaderHeightAction
{
    return _headerTableViewHeaderHeightAction;
}
-(void)setHeaderTableViewHeaderHeightAction:(CGFloat (^)(HeaderTableView *))headerTableViewHeaderHeightAction
{
    _headerTableViewHeaderHeightAction = headerTableViewHeaderHeightAction;
    
    // reset it
    [self restoreConstraints];
}

@end





