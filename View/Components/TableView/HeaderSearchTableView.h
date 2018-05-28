#import "HeaderTableView.h"
#import "SearchBarView.h"

@interface HeaderSearchTableView : HeaderTableView <SearchBarViewDelegate>

@property (strong) SearchBarView* searchBar;

@property (assign,nonatomic) BOOL hideSearchBar;    // default NO , use it to hide search bar temporary.

@property (assign,nonatomic) CGFloat searchBarHeight;

@end
