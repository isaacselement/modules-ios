
#import "PickerViewBase.h"
#import "DictionaryHelper.h"


@interface PickerViewBase ()
{
    
    void(^_pickerViewBasedDidSelectAction)(PickerViewBase* pickerView, NSInteger row, NSInteger component);
}


@end

@implementation PickerViewBase


@synthesize proxy;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultVariables];
    }
    return self;
}

-(void) setDefaultVariables
{
    self.delegate = self;
    self.dataSource = self;
}




#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.contents.count;
}


#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.contents objectAtIndex: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewBasedDidSelectAction) {
        self.pickerViewBasedDidSelectAction(self, row, component);
    } else if (proxy && [proxy respondsToSelector:@selector(pickerViewBase:didSelectRow:inComponent:)]){
        [proxy pickerViewBase:self didSelectRow:row inComponent:component];
    }
}



@end






@implementation PickerViewBase (ActionBlock)

-(void (^)(PickerViewBase *, NSInteger, NSInteger))pickerViewBasedDidSelectAction
{
    return _pickerViewBasedDidSelectAction;
}

-(void)setPickerViewBasedDidSelectAction:(void (^)(PickerViewBase *, NSInteger, NSInteger))pickerViewBasedDidSelectAction
{
    _pickerViewBasedDidSelectAction = pickerViewBasedDidSelectAction;
}

@end
