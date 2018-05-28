#import "NormalTextField.h"


// http://blog.csdn.net/worldmatrix/article/details/8002255
@interface NormalTextFieldDelegate : NSObject <UITextFieldDelegate>

@end


@implementation NormalTextFieldDelegate
{
    NSString* oldText;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(NormalTextField *)textField
{
    oldText = textField.text;
    if (textField.textFieldDidBeginEditingBlock) {
        textField.textFieldDidBeginEditingBlock(textField);
    }
}

- (void)textFieldDidEndEditing:(NormalTextField *)textField
{
    if (textField.textFieldDidEndEditingBlock) {
        textField.textFieldDidEndEditingBlock(textField, oldText);
    }
}

- (BOOL)textField:(NormalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.textFieldShouldChangeBlock) {
        return textField.textFieldShouldChangeBlock(textField,range,string);
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(NormalTextField *)textField
{
    if (textField.textFieldShouldReturnBlock) {
        return textField.textFieldShouldReturnBlock(textField);
    }
    return YES;
}

@end







// TODO : Subclass a inner shadow view.
@implementation NormalTextField
{
    int addCount ;
    id<UITextFieldDelegate> preDelegate;
    NormalTextFieldDelegate* normalTextFieldDelegate;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeDefaultVariables];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDefaultVariables];
    }
    return self;
}

-(void) initializeDefaultVariables
{
    self.adjustsFontSizeToFitWidth = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}



#pragma mark - 

-(void)setTextFieldEditingChangedBlock:(void (^)(NormalTextField *))textFieldEditingChangedBlock
{
    _textFieldEditingChangedBlock = textFieldEditingChangedBlock;
    if (textFieldEditingChangedBlock) {
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    } else {
        [self removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

-(void) textFieldDidChange:(UITextField*)sender
{
    if (self.textFieldEditingChangedBlock) {
        self.textFieldEditingChangedBlock(self);
    }
}


#pragma mark - 

-(void)setText:(NSString *)newText
{
    NSString* previousText = self.text;
    
    BOOL shouldSetText = YES;
    
    if (self.textFieldShouldSetTextBlock) {
        shouldSetText = self.textFieldShouldSetTextBlock(self, newText);
    }
    
    if (!shouldSetText) return;
    
    [super setText: newText];
    
    if (self.textFieldDidSetTextBlock) {
        self.textFieldDidSetTextBlock(self, previousText);
    }
}


#pragma mark -

-(void)setTextFieldDidBeginEditingBlock:(void (^)(NormalTextField *))textFieldDidBeginEditingBlock
{
    _textFieldDidBeginEditingBlock = textFieldDidBeginEditingBlock;
    if (textFieldDidBeginEditingBlock) {
        [self addNormalTextFieldDelegate];
    } else {
        [self removeNormalTextFieldDelegate];
    }
}

-(void)setTextFieldDidEndEditingBlock:(void (^)(NormalTextField *, NSString *))textFieldDidEndEditingBlock
{
    _textFieldDidEndEditingBlock = textFieldDidEndEditingBlock;
    if (textFieldDidEndEditingBlock) {
        [self addNormalTextFieldDelegate];
    } else {
        [self removeNormalTextFieldDelegate];
    }
}


#pragma mark - Private 

-(void) addNormalTextFieldDelegate
{
    if (! normalTextFieldDelegate) {
        normalTextFieldDelegate = [[NormalTextFieldDelegate alloc] init];
        if (self.delegate != normalTextFieldDelegate) {
            preDelegate = self.delegate;
        }
    }
    
    addCount ++;
    self.delegate = normalTextFieldDelegate;
}
-(void) removeNormalTextFieldDelegate
{
    addCount --;
    if (addCount == 0) {
        self.delegate = preDelegate;
        normalTextFieldDelegate = nil;
    }
}


@end
