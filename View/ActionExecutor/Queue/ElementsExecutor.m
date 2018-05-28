#import "ElementsExecutor.h"
#import "_ActionExecutor_.h"

#import "KeyValueHelper.h"


@implementation ElementsExecutor

-(void)execute:(NSDictionary *)config objects:(NSArray *)objects values:(NSArray *)values times:(NSArray *)times durationsRep:(NSMutableArray *)durationsQueue beginTimesRep:(NSMutableArray *)beginTimesQueue
{
    for (int i = 0; i < objects.count; i++) {
        
        id object = [objects objectAtIndex: i];
        NSString* subObject = config[@"object"];
        if (subObject) {
            object = [object valueForKeyPath: subObject];
        }
        
        id value = config[@"values"];                                   // Not key 'values' , regard as nil ~~~~
        NSString* keyPath = config[@"keyPath"];
        CFTimeInterval stepTime = [config[@"stepTime"] doubleValue];    // default 0
        
        
        // so here , "transitions" is for UIView , and , "disableTransaction" is for CALayer
        
        
        NSArray* transitions = config[@"transitions"];
        if ([object isKindOfClass:[UIView class]] && transitions) {
            
            NSUInteger options = [self getUIViewAnimationOptions: transitions];
            [UIView transitionWithView: object duration:stepTime options:options animations:^{
                [self setTransitionValue:value object:object keyPath:keyPath];
            } completion:nil];
            
        } else if ([object isKindOfClass:[CALayer class]]) {
            
            BOOL enableAction = [config[@"disableTransaction"] boolValue];        // default NO
            [CATransaction begin];
            [CATransaction setAnimationDuration: stepTime];
            [CATransaction setDisableActions: enableAction];               // so here , default enable the transition
            [self setTransitionValue:value object:object keyPath:keyPath];
            [CATransaction commit];
            
        } else {
            
            [self setTransitionValue:value object:object keyPath:keyPath];
            
        }
    }
}

-(void) setTransitionValue:(id)value object:(NSObject*)object keyPath:(NSString*)keyPath
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        id obj = object;
        if (keyPath) obj = [object valueForKeyPath: keyPath];
        [[KeyValueHelper sharedInstance] setValues: value object:obj];
    } else {
        [[KeyValueHelper sharedInstance] setValue: value keyPath:keyPath object:object];
    }
}

-(NSUInteger) getUIViewAnimationOptions: (NSArray*)options
{
    NSUInteger results = UIViewAnimationOptionCurveEaseInOut;
    for (int i = 0; i < options.count; i++) {
        int v = [options[i] intValue];
        NSUInteger next = UIViewAnimationOptionTransitionNone;
        
        switch (v) {
            case 0:
                next = UIViewAnimationOptionLayoutSubviews;
                
                break;
            case 1:
                next = UIViewAnimationOptionAllowUserInteraction;
                
                break;
            case 2:
                next = UIViewAnimationOptionBeginFromCurrentState;
                
                break;
            case 3:
                next = UIViewAnimationOptionRepeat;
                
                break;
            case 4:
                next = UIViewAnimationOptionAutoreverse;
                
                break;
            case 5:
                next = UIViewAnimationOptionOverrideInheritedDuration;
                
                break;
            case 6:
                next = UIViewAnimationOptionOverrideInheritedCurve;
                
                break;
            case 7:
                next = UIViewAnimationOptionAllowAnimatedContent;
                
                break;
            case 8:
                next = UIViewAnimationOptionShowHideTransitionViews;
                
                break;
            case 9:
                next = UIViewAnimationOptionOverrideInheritedOptions;
                
                break;
            case 10:
                next = UIViewAnimationOptionCurveEaseInOut;
                
                break;
            case 11:
                next = UIViewAnimationOptionCurveEaseIn;
                
                break;
            case 12:
                next = UIViewAnimationOptionCurveEaseOut;
                
                break;
            case 13:
                next = UIViewAnimationOptionCurveEaseInOut;
                
                break;
            case 14:
                next = UIViewAnimationOptionTransitionNone;
                
                break;
            case 15:
                next = UIViewAnimationOptionTransitionFlipFromLeft;
                
                break;
            case 16:
                next = UIViewAnimationOptionTransitionFlipFromRight;
                
                break;
            case 17:
                next = UIViewAnimationOptionTransitionCurlUp;
                
                break;
            case 18:
                next = UIViewAnimationOptionTransitionCurlDown;
                
                break;
            case 19:
                next = UIViewAnimationOptionTransitionCrossDissolve;
                
                break;
            case 20:
                next = UIViewAnimationOptionTransitionFlipFromTop;
                
                break;
            case 21:
                next = UIViewAnimationOptionTransitionFlipFromBottom;
                
                break;
                
            default:
                break;
        }
        
        results = results | next;
    }
    return results;
}

@end
