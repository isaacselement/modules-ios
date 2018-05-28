#import "KeyBoardHelper.h"
#import "UIView+Frame.h"
#import <objc/runtime.h>
#import "UIView+Additions.h"


//#ifdef DEBUG
//
//#ifndef _______DLOG
//
//#define _______DLOG(format, ...) NSLog(format, ##__VA_ARGS__)
//
//#else
//
//#define _______DLOG(format, ...)
//
//#endif
//
//#endif


@interface KeyBoardHelper() <UIGestureRecognizerDelegate>

@end


static const char* textViewIncrementSizeHeightKey = "textViewIncrementSizeHeightKey";


@implementation KeyBoardHelper
{
    UIView* editView;
    UIView* adjustView;
    
    CGFloat adjustViewOriginY;
    
    /*! To save keyboard size. */
    CGSize keyboardSize;
    
    /*! TapGesture to resign keyboard on view's touch. */
    UITapGestureRecognizer *tapGesture;
}


@synthesize isKeyboardShowing = _isKeyboardShowing;


+(instancetype) sharedInstance
{
    static KeyBoardHelper* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //  Registering for keyboard notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        
        //  Registering for textField notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        
        //  Registering for textView notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        //Creating gesture for @shouldResignOnTouchOutside
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [tapGesture setDelegate:self];
        
        
        // default values
        self.keyboardDistanceFromTextView = 5;
        self.keyboardDistanceFromTextField = 25;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

/*! Resigning on tap gesture. */
- (void)tapRecognized:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [gesture.view endEditing:YES];
    }
}

#pragma mark - NSNotificationCenter

// IOS 7 & 8 Sequence:
// keyboardWillHide -> textField/ViewDidEndEditing

// A . When Keyboard not showing, firt time click editable view:
// TextField (S1): textFieldDidBeginEditing -> keyboardWillChangeFrame -> keyboardWillShow
// TextView (S2): keyboardWillChangeFrame -> keyboardWillShow -> textViewDidBeginEditing

// B . When Keyboard is showing, switch editable view between editable view :
// ("-8-...-8-") : But in IOS 8, and switch password TextField between normal editable view, will cause "keyboardWillChangeFrame" squence
// TextField: previous.textFieldDidBeginEditing -> next.textFieldDidBeginEditing -> -8-(S1: keyboardWillChangeFrame -> keyboardWillShow)-8-
// TextView: previous.textViewDidEndEditing -> -8-(S2: keyboardWillChangeFrame -> keyboardWillShow)-8- -> next.textViewDidBeginEditing

-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
//    _______DLOG(@"keyboardWillChangeFrame");
}

-(void)keyboardWillShow:(NSNotification*)notification
{
//    _______DLOG(@"keyboardWillShow");
    // in B and ios 8 situation
    if (! self.isKeyboardShowing) {
        adjustView = [UIView getTopView];
        adjustViewOriginY = [adjustView originY];
    }
    _isKeyboardShowing = YES;
    
    keyboardSize = [KeyBoardHelper getKeyboardSizeByKeyboardNotification: notification];
//    _______DLOG(@"get ++++++ keyboardSize :  %@", NSStringFromCGSize(keyboardSize));
    
    [self executeAdjustFrameWork];
    
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addGestureRecognizer: tapGesture];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
//    _______DLOG(@"keyboardWillHide");
    [self restoreFrame];
    
    
    adjustView = nil;
    adjustViewOriginY = 0;
    _isKeyboardShowing = NO;
    
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window removeGestureRecognizer: tapGesture];
}



// TextField

-(void)textFieldDidBeginEditing:(NSNotification*)notification
{
//    _______DLOG(@"textFieldDidBeginEditing");
    editView = notification.object;
    [self executeAdjustFrameWork];
}

-(void)textFieldDidEndEditing:(NSNotification*)notification
{
//    _______DLOG(@"textFieldDidEndEditing");
    
    editView = nil;
}


// TextView

-(void)textViewDidBeginEditing:(NSNotification*)notification
{
//    _______DLOG(@"textViewDidBeginEditing");
    editView = notification.object;
    [self executeAdjustFrameWork];
}

-(void)textViewDidEndEditing:(NSNotification*)notification
{
//    _______DLOG(@"textViewDidEndEditing");
    
    UIView* editingView = editView;
    NSNumber* addSizeHeightNum = objc_getAssociatedObject(editingView, textViewIncrementSizeHeightKey);
    if (addSizeHeightNum) {
        CGFloat addSizeHeight = [addSizeHeightNum floatValue];
        [UIView animateWithDuration:0.3 animations:^{
            [editingView addSizeHeight: -addSizeHeight];
        } completion:nil];
        objc_setAssociatedObject(editingView, textViewIncrementSizeHeightKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
    
    editView = nil;
}

-(void)textViewDidChange:(NSNotification*)notification
{
//    _______DLOG(@"textViewDidChange");
}




#pragma mark -

// Base on the Sequence above, we found a way like this ...
-(void) executeAdjustFrameWork
{
//    _______DLOG(@"--- executeAdjustFrameWork");
    SEL executeSelector = @selector(executeAdjustFrameWork);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:executeSelector object:nil];
    
    if (self.isKeyboardShowing && adjustView && editView) {
        SEL adjustSelector = @selector(adjustFrame);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:adjustSelector object:nil];
        [self performSelector:adjustSelector withObject:nil afterDelay:0.1];
    } else {
//        _______DLOG(@"--- next time executeAdjustFrameWork");
        [self performSelector:executeSelector withObject:nil afterDelay: 0.1];
    }
}

// Base on this two following rules:
// A . editingView.superview * n == adjustingView ([ViewHelper getTopView])
// B . rootView ([ViewHelper getRootView]) != adjustingView ([ViewHelper getTopView])  // To be test and solve ...
-(void) adjustFrame
{
//    _______DLOG(@"+++ adjustFrame");
    UIView* editingView = editView;
    UIView* adjustingView = adjustView;
    CGSize keyBoardSize = keyboardSize;
    CGFloat adjustingViewOriginY = adjustViewOriginY;
    CGFloat keyBoardDistanceFromTextView = self.keyboardDistanceFromTextView;
    CGFloat keyBoardDistanceFromTextField = self.keyboardDistanceFromTextField;
    
    
    // caculate the editingViewBaseline
    UIView* rootView = [UIView getRootView];
    CGPoint editingViewPoint = [rootView convertPoint: [editingView origin] fromView:[editingView superview]];
    CGFloat editingViewBaseline = editingViewPoint.y + [editingView sizeHeight];
    
    // this situation ~~~
    if (adjustView == rootView) {
//        _______DLOG(@"do some with editingViewBaseline ...");
    }
    
    // caculate the keyBoardBaseline
    CGFloat keyBoardBaseline = [self getKeyboardBaseline: keyBoardSize];
    
    // caculate the cover height. coverHeight < 0 , need to go up. coverHeight > 0 , need to go down
    CGFloat coverHeight = keyBoardBaseline - editingViewBaseline ;
    
    
    // caculate the adjust distance, check UITextView and UITextField
    CGFloat distance = coverHeight;
    
    if ([editingView isKindOfClass:[UITextField class]]) {
        distance -= keyBoardDistanceFromTextField;
        
    } else if ([editingView isKindOfClass:[UITextView class]]) {
        distance -= keyBoardDistanceFromTextView;
        
        // shorten the height to fixed
        CGFloat textViewFinalY = editingViewPoint.y + distance;
        if (textViewFinalY < 0) {
            distance -= textViewFinalY;
        }
        objc_setAssociatedObject(editingView, textViewIncrementSizeHeightKey, @(textViewFinalY), OBJC_ASSOCIATION_RETAIN);
        [UIView animateWithDuration:0.3 animations:^{
            [editingView addSizeHeight: textViewFinalY];
        } completion:nil];
        
    }
    
    
    // after got the distance
    
    // caculate the adjust view y coordinate
    // !!!! Weird Problem!!!!! CGFloat y !!!!! Not working!!!
    // when y is CGFloat, the editing view in TableViewCell, no animation!!!
    int y = [adjustingView originY] + distance;
    if (y > adjustingViewOriginY) {
        y = adjustingViewOriginY;
        distance = 0;
    }
    if ([adjustingView originY] == y) return;
    
    
//    _______DLOG(@"adjustFrame -up +down : %d", y);
    [UIView animateWithDuration: 0.5 animations:^{
        [adjustingView setOriginY: y];
    } completion:nil];

}

-(void) restoreFrame
{
    UIView* adjustingView = adjustView;
    [UIView animateWithDuration: 0.3 animations:^{
        [adjustingView setOriginY: adjustViewOriginY];
    } completion:nil];
}


-(CGFloat) getKeyboardBaseline: (CGSize)keyBoardSize
{
    // caculate the keyBoardBaseline
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat keyBoardBaseline = screenSize.height - keyBoardSize.height;
    return keyBoardBaseline;
}


#pragma mark - Class Methods

+(CGSize) getKeyboardSizeByKeyboardNotification: (NSNotification*)notification
{
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat _long_ = keyBoardSize.width > keyBoardSize.height ? keyBoardSize.width : keyBoardSize.height ;
    CGFloat _short_ = keyBoardSize.width < keyBoardSize.height ? keyBoardSize.width : keyBoardSize.height;
    
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIView getTopViewController].interfaceOrientation);
    keyBoardSize = isPortrait ? CGSizeMake(_short_, _long_) : CGSizeMake(_long_, _short_);
    
    return keyBoardSize;
}

@end
