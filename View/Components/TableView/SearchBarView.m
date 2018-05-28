#import "SearchBarView.h"
#import "FrameTranslater.h"
#import "ViewHelper.h"


@implementation SearchBarView
{
    UIEdgeInsets _edgeInsets;
}

@synthesize textField;
@synthesize cancelButton;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _edgeInsets = UIEdgeInsetsMake(CanvasH(5), CanvasW(20), CanvasH(5), CanvasW(20));
        [self initializeSubviews];
        [self setSubviewsVConstraints];
    }
    return self;
}

-(void) initializeSubviews
{
    self.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
    
    // textfield
    textField = [[UITextField alloc] init];
    
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.adjustsFontSizeToFitWidth = YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:25]];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    // Add a "textFieldDidChange" notification method to the text field control.
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    // insert the search icon/ magnify glass icon
    // Google "Emoji" for more informations : http://stackoverflow.com/a/11815568
    
//    UILabel *magnifyingGlass = [[UILabel alloc] init];
//    NSString* string = [[NSString alloc] initWithUTF8String:"\xF0\x9F\x8D\xB0"]; // \xF0\x9F\x94\x8D
//    magnifyingGlass.text = string;
//    [magnifyingGlass sizeToFit];
//    textField.leftView = magnifyingGlass;
//    textField.leftViewMode = UITextFieldViewModeAlways;
    
    // cancel button
    cancelButton = [[UIButton alloc] init];
    
    [cancelButton setTitle: @"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:  cancelButton.tintColor forState:UIControlStateNormal];
    [cancelButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [cancelButton.titleLabel.font fontWithSize: [FrameTranslater convertFontSize: 25]];
    [cancelButton addTarget: self action:@selector(cancelButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];

    // constraints
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview: textField];
    [self addSubview: cancelButton];
}

-(void)setHiddenCancelButton:(BOOL)hidden
{
    cancelButton.hidden = hidden;
    [self setSubviewsVConstraints];
}


-(void) setContentEdgeInsets: (UIEdgeInsets)insets
{
    _edgeInsets = insets;
    [self setSubviewsVConstraints];
}


-(void) setSubviewsVConstraints
{
    [self removeConstraints: self.constraints];
    [self initializeSubviewsHConstraints];
    [self initializeSubviewsVConstraints];
}

-(void) initializeSubviewsHConstraints
{
    float insetLeft = _edgeInsets.left;
    float insetRight = _edgeInsets.right;
    NSString* format = nil;
    if (cancelButton.hidden) {
        format = @"|-(insetLeft)-[textField]-(insetRight)-|";
    } else {
        format = @"|-(insetLeft)-[textField]-(insetLeft)-[cancelButton]-(insetRight)-|";
    }
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:format
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"insetLeft":@(insetLeft), @"insetRight": @(insetRight)}
                          views:NSDictionaryOfVariableBindings(textField,cancelButton)]];
}

-(void) initializeSubviewsVConstraints
{
    float insetTop = _edgeInsets.top;
    float insetBottom = _edgeInsets.bottom;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-(insetTop)-[textField]-(insetBottom)-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:@{@"insetTop":@(insetTop), @"insetBottom":@(insetBottom)}
                          views:NSDictionaryOfVariableBindings(textField)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-(insetTop)-[cancelButton]-(insetBottom)-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:@{@"insetTop":@(insetTop), @"insetBottom":@(insetBottom)}
                          views:NSDictionaryOfVariableBindings(cancelButton)]];
}




#pragma mark - Event

-(void) cancelButtonTapAction: (id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewCancelButtonClicked:)]) {
        [delegate searchBarViewCancelButtonClicked: self];
    }
}

-(void) textFieldDidChange:(UITextField*)sender
{
    NSString* text = sender.text;
    if (delegate && [delegate respondsToSelector:@selector(searchBarView:textDidChange:)]) {
        [delegate searchBarView: self textDidChange:text];
    }
}



#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//- (void)textFieldDidEndEditing:(UITextField *)textField
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
- (BOOL)textFieldShouldClear:(UITextField *)textFieldObj
{
    textFieldObj.text = nil;
    [self textFieldDidChange: textFieldObj];
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textFieldObj
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewSearchButtonClicked:)]) {
        [delegate searchBarViewSearchButtonClicked: self];
    }
    return YES;
}


@end
