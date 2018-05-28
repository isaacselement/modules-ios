#import <UIKit/UIKit.h>

@interface NormalTextField : UITextField


// target action UIControlEventEditingChanged
@property (copy, nonatomic) void (^textFieldEditingChangedBlock) (NormalTextField* textField);





// in setText:
@property (copy) BOOL (^textFieldShouldSetTextBlock) (NormalTextField* textField, NSString* newText);
@property (copy) void (^textFieldDidSetTextBlock) (NormalTextField* textField, NSString* oldText);





// in UITextFieldDelegate
@property (copy, nonatomic) void (^textFieldDidBeginEditingBlock) (NormalTextField* textField);

@property (copy, nonatomic) void (^textFieldDidEndEditingBlock) (NormalTextField* textField, NSString* oldText);

@property (copy, nonatomic) BOOL (^textFieldShouldChangeBlock)(NormalTextField* textField, NSRange range, NSString* replacementString);

@property (copy, nonatomic) BOOL (^textFieldShouldReturnBlock)(NormalTextField* textField);






#pragma mark - Override Methods

-(void) initializeDefaultVariables;


@end
