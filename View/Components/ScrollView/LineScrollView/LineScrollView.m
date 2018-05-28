#import "LineScrollView.h"
#import "LineScrollViewCell.h"

#import "ViewHelper.h"
#import "UIView+Frame.h"
#import "NSArray+Additions.h"

#define kEACHCELLWIDTH_KEYPATH @"eachCellWidth"

@implementation LineScrollView {
    Class __cellClass;
    float previousOffsetx;
}

@synthesize currentIndex;
@synthesize contentView;
@synthesize dataSource;
@synthesize currentDirection;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        contentView = [[UIView alloc] init];
        [self addSubview: contentView];
        
        __cellClass = [LineScrollViewCell class];
    
        self.delaysContentTouches = NO;             // call touchesBegan: immediately
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;

        [self addObserver: self forKeyPath:kEACHCELLWIDTH_KEYPATH options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [self addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapAction:)]];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kEACHCELLWIDTH_KEYPATH]) {
        if ([change[@"old"] floatValue] != [change[@"new"] floatValue]) {
            [self reloadCells];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    LineScrollViewCell* cell = (LineScrollViewCell*)[self hitTest:location withEvent:nil];
    if (!cell || ![cell isKindOfClass:[LineScrollViewCell class]]) return;
    
    if (self.lineScrollViewTouchBeganAtCell) {
        self.lineScrollViewTouchBeganAtCell(self, cell);
    } else if (dataSource && [dataSource respondsToSelector: @selector(lineScrollView:touchBeganAtCell:)]) {
        [dataSource lineScrollView: self touchBeganAtCell:cell];
    }
}

-(void) aTapAction: (UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView: gesture.view];
    LineScrollViewCell* cell = (LineScrollViewCell*)[self hitTest:location withEvent:nil];
    if (!cell || ![cell isKindOfClass:[LineScrollViewCell class]]) return;

    if (self.lineScrollViewTouchEndedAtCell) {
        self.lineScrollViewTouchEndedAtCell(self, cell);
    } else if (dataSource && [dataSource respondsToSelector: @selector(lineScrollView:touchEndedAtCell:)]) {
        [dataSource lineScrollView: self touchEndedAtCell:cell];
    }
}

-(void)setCurrentIndex:(int)index
{
    currentIndex = index;
    [self reloadCells];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(frame, self.frame)) {
        return;
    }
    // call super
    [super setFrame: frame];
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    [self reloadCells];
}

-(void) reloadCells
{
    CGRect frame = self.frame;
    if (CGRectEqualToRect(frame, CGRectNull)) return;
        
    float width = frame.size.width;
    float height = frame.size.height;
    if (width == 0 || height == 0) return;
    
    // subviews are LineScrollViewCell
    NSArray* subviews = contentView.subviews;
    for (UIView* view in subviews) {
        [view removeFromSuperview];
    }

    currentDirection = NO;
    
    // begin
    CGFloat perCellHeight = self.eachCellHeight;
    CGFloat perCellWidth = self.eachCellWidth;
    CGFloat perCellY = (height - perCellHeight) / 2;
    // while eachCellWidth not set, return
    if (perCellWidth == 0.0f) {
        return;
    }
    
    int visibleCount = width / perCellWidth;
    int cellsCount = visibleCount + 2;  // need two to reuse
    float allCellsLength = cellsCount * perCellWidth;
    
    int subviewIndex = 0;               // for reuse reason
    int showedViewCount = 0 ;
    currentIndex -= cellsCount;
    for (int i = 0 ; i < cellsCount; i++) {
        currentIndex++;
        if (![self shouldShowNextIndex:currentIndex isReload:YES]) {
            continue;
        }
        showedViewCount++;
        LineScrollViewCell* cell = [subviews safeObjectAtIndex:subviewIndex];
        subviewIndex++;
        if (! cell) {
            cell = [[__cellClass alloc] init];
        }
        // set the origin y and size first
        [cell setOriginY:perCellY];
        [cell setSize:CGSizeMake(perCellWidth, perCellHeight)];
        [contentView addSubview: cell];
        // cause willShowIndex Method will use the cell view , should added first
        if (self.lineScrollViewWillShowIndex) {
            self.lineScrollViewWillShowIndex(self, currentIndex, YES);
        } else if (dataSource && [dataSource respondsToSelector: @selector(lineScrollView:willShowIndex:isReload:)]) {
            [dataSource lineScrollView: self willShowIndex:currentIndex isReload:YES];
        }
    }
    
    // set the origin x by showedViewCount
    float perCellX = (allCellsLength - showedViewCount * perCellWidth) / 2;
    for (int i = 0; i < showedViewCount; i++) {
        LineScrollViewCell* cell = [contentView.subviews safeObjectAtIndex:i];
        [cell setOriginX:perCellX];
        perCellX += perCellWidth;
    }
    
    self.contentSize = CGSizeMake(allCellsLength, height);
    contentView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // check if change direction
    BOOL direction = self.contentOffset.x < previousOffsetx;
    if (currentDirection != direction) {
        NSUInteger count = contentView.subviews.count ;
        if (direction) {
            currentIndex -= (count - 1);
        } else {
            currentIndex += (count - 1);
        }
    }
    currentDirection = direction;
    
    // self.contentOffset.x == 0 is the first time call layoutSubviews by iOS
    if (self.contentOffset.x != 0) {
        int nextIndex = currentDirection ? currentIndex - 1 : currentIndex + 1;
        if ([self shouldShowNextIndex: nextIndex isReload:NO]) {
            [self relocateIfNecessary];
        }
    }
}

#pragma mark - Private Methods

- (BOOL)shouldShowNextIndex: (int)nextIndex isReload:(BOOL)isReload
{
    BOOL shouldShowNextIndex = YES;
    if (self.lineScrollViewShouldShowIndex) {
        shouldShowNextIndex = self.lineScrollViewShouldShowIndex(self, nextIndex);
    } else if (dataSource && [dataSource respondsToSelector:@selector(lineScrollView:shouldShowIndex:isReload:)]) {
        shouldShowNextIndex = [dataSource lineScrollView:self shouldShowIndex:nextIndex isReload:(BOOL)isReload];
    }
    return shouldShowNextIndex;
}

// content periodically to achieve impression of infinite scrolling
- (void)relocateIfNecessary
{
    // Forward Left
    if (self.contentOffset.x > self.eachCellWidth) {
        [self relocateSubviews: NO];
        
    // Forward Right
    } else if (self.contentOffset.x < 0 ) {
        [self relocateSubviews: YES];
    }
    previousOffsetx = self.contentOffset.x;
}

// isHeadRight means self.contentOffset.x is increasing!!!
-(void) relocateSubviews: (BOOL)isHeadingRight
{
    if (isHeadingRight) {
        [self alignRight];
        currentIndex -- ;
    } else {
        [self reLeft];
        currentIndex ++ ;
    }

    // reset the x coordinate
    NSArray* subviews = contentView.subviews;       // subviews are LineScrollViewCell
    NSUInteger count = subviews.count;
    float xc[count] ;
    
    for (int i = 0; i < count; i++) {
        if (i == 0) xc[i] = [subviews[i] originX];
        else xc[i] = [subviews[i - 1] originX] + [subviews[i - 1] sizeWidth];
    }
    
    for (int i = 0; i < count; i++) {
        UIView* view = subviews[i];
        int j = isHeadingRight ?(i+1):(i-1);
        NSUInteger k = (j + count) % count;
        int x = xc[k];          // int will be better
        [view setOriginX: x];
    }
    
    // sort the subviews by x coordinate
    [ViewHelper sortedSubviewsByXCoordinate: contentView];
    
    
    // call delegate
    if (self.lineScrollViewWillShowIndex) {
        self.lineScrollViewWillShowIndex(self, currentIndex, NO);
    } else if (dataSource && [dataSource respondsToSelector: @selector(lineScrollView:willShowIndex:isReload:)]) {
        [dataSource lineScrollView: self willShowIndex:currentIndex isReload:NO];
    }
}

#pragma mark - Public Methods

-(void) registerCellClass:(Class)cellClass
{
    __cellClass = cellClass;
}

-(LineScrollViewCell *)visibleCellAtIndex:(int)index
{
    return [contentView.subviews safeObjectAtIndex: (index - [self mostLeftIndex])];
}

-(int) indexOfVisibleCell: (LineScrollViewCell*)cell
{
    return (int)[contentView.subviews indexOfObject: cell] + [self mostLeftIndex];
}


#pragma mark - Utilities Methods

-(int) mostLeftIndex
{
    return currentDirection ? currentIndex : currentIndex - ((int)contentView.subviews.count - 1) ;
}

-(void) alignRight
{
    self.contentOffset = CGPointMake(self.eachCellWidth, self.contentOffset.y);
}

-(void) reLeft {
    self.contentOffset = CGPointMake(0, self.contentOffset.y);
}
-(void) reRight {
    self.contentOffset = CGPointMake(self.contentSize.width - self.bounds.size.width, self.contentOffset.y);
}
-(void) reCenter {
    self.contentOffset = CGPointMake((self.contentSize.width - self.bounds.size.width)/2, self.contentOffset.y);
}


@end
