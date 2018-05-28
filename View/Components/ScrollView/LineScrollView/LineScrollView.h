#import <UIKit/UIKit.h>


@class LineScrollView;
@class LineScrollViewCell;


/*
 Usage i.e:
 
 LineScrollView* lineScrollView = [[LineScrollView alloc] init];
 [lineScrollView registerCellClass: [ImageLabelLineScrollCell class]]; // ImageLabelLineScrollCell is LineScrollViewCell's subClass
 lineScrollView.dataSource = self;
 [self.view addSubview: lineScrollView];
 
 
 lineScrollView.backgroundColor = [UIColor grayColor];
 lineScrollView.eachCellWidth = 50;
 lineScrollView.currentIndex = 7;
 lineScrollView.frame = CGRectMake(0, 100, 320, 80);
 
 */


@protocol LineScrollViewDataSource <NSObject>


@optional

-(BOOL)lineScrollView:(LineScrollView *)lineScrollView shouldShowIndex:(int)index isReload:(BOOL)isReload;
-(void)lineScrollView:(LineScrollView *)lineScrollView willShowIndex:(int)index isReload:(BOOL)isReload;
-(void)lineScrollView:(LineScrollView *)lineScrollView touchBeganAtCell:(LineScrollViewCell *)cell;
-(void)lineScrollView:(LineScrollView *)lineScrollView touchEndedAtCell:(LineScrollViewCell *)cell;


@end



@interface LineScrollView : UIScrollView


@property (assign) CGFloat eachCellWidth;   // should be CGFloat ! important !!! cause will raise the caculate problem
@property (assign) CGFloat eachCellHeight;

@property (assign, nonatomic) int currentIndex;


@property (strong, readonly) UIView* contentView;

// Yes : is heading right, currentIndex is decrease, contentOffset.x is decrease
@property (assign, readonly) BOOL currentDirection;


@property (assign) id<LineScrollViewDataSource> dataSource;


@property (copy) BOOL(^lineScrollViewShouldShowIndex)(LineScrollView *lineScrollView, int index);
@property (copy) void(^lineScrollViewWillShowIndex)(LineScrollView *lineScrollView, int index, BOOL isReload);
@property (copy) void(^lineScrollViewTouchBeganAtCell)(LineScrollView *lineScrollView, LineScrollViewCell *cell);
@property (copy) void(^lineScrollViewTouchEndedAtCell)(LineScrollView *lineScrollView, LineScrollViewCell *cell);





#pragma mark - Public Methods

-(void) registerCellClass:(Class)cellClass;

-(LineScrollViewCell*) visibleCellAtIndex: (int)index;

-(int) indexOfVisibleCell: (LineScrollViewCell*)cell;


@end
