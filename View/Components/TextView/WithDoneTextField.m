#import "WithDoneTextField.h"

@implementation WithDoneTextField


-(void)initializeDefaultVariables
{
    [super initializeDefaultVariables];
    
    
    // append the toolbar with 'done' button to the keyboard
    UIToolbar * keyboardHeaderToolBar = [[UIToolbar alloc] init];
    [keyboardHeaderToolBar sizeToFit];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignFirstResponder)];
    keyboardHeaderToolBar.items = [NSArray arrayWithObjects: spaceItem, doneItem, nil];
    self.inputAccessoryView = keyboardHeaderToolBar;
}


@end
