#import <UIKit/UIKit.h>

@class SearchBarView;

@protocol SearchBarViewDelegate <NSObject>

@optional
- (void)searchBarView:(SearchBarView *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarViewCancelButtonClicked:(SearchBarView *) searchBar;
- (void)searchBarViewSearchButtonClicked:(SearchBarView *)searchBar;    // the keyboard search button

@end



@interface SearchBarView : UIView <UITextFieldDelegate>

@property (strong) UITextField* textField;
@property (strong) UIButton* cancelButton;

@property (assign) id<SearchBarViewDelegate> delegate;

-(void) setHiddenCancelButton:(BOOL)hidden;
-(void) setContentEdgeInsets: (UIEdgeInsets)insets;


@end
