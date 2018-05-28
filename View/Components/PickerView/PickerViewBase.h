#import <UIKit/UIKit.h>

@class PickerViewBase;

@protocol PickerViewBaseProxy <NSObject>

@optional

- (void)pickerViewBase:(PickerViewBase *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end




@interface PickerViewBase : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>


// can be NSDictionary and NSArray
// when NSDictionary , the key will be the first row, then the content
// When NSArray , then just one row
@property (strong) NSArray* contents;


@property (assign) id<PickerViewBaseProxy> proxy;


@end



@interface PickerViewBase (ActionBlock)

@property (copy) void(^pickerViewBasedDidSelectAction)(PickerViewBase* pickerView, NSInteger row, NSInteger component);

@end;