#import "QueueTimeCalculator.h"
#import "_ActionExecutor_.h"

@implementation QueueTimeCalculator
{
    double onePhaseDuration;
    double longestDuration; // can be many exectutors  (ActionExecutorManager runActionExecutors:)
}



#pragma mark - Public Methods

-(void) clear
{
    longestDuration = 0;
}

-(double) take
{
    return longestDuration;
}

-(void) justClearOnePhase
{
    onePhaseDuration = 0;
}

-(double) justTakeOnePhase
{
    return onePhaseDuration;
}

#pragma mark - QueueExecutorDelegate

-(void)queue:(QueueExecutorBase*)executor beginTimes:(NSArray*)beginTimes durations:(NSArray*)durations
{
    double oneQueueDuration = [[QueueTimeCalculator getExtremeValue: durations isMax:YES] doubleValue];
    if (longestDuration < oneQueueDuration) {
        longestDuration = oneQueueDuration;
    }
    
    if (onePhaseDuration < oneQueueDuration) {
        onePhaseDuration = oneQueueDuration;
    }
}

-(void)queueDidStart:(QueueExecutorBase*)executor animation:(CAAnimation *)anim
{
    
}

-(void)queueDidStop:(QueueExecutorBase*)executor animation:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

#pragma mark - Class Methods

+(NSNumber*) getExtremeValue: (NSArray*)numbers isMax:(BOOL)isMax
{
    NSArray* compares = numbers;
    
    // two dimensional
    if ([ArrayHelper isTwoDimension: numbers]) {
        NSMutableArray* oneDmensionInnerArrayExtremeValues = [NSMutableArray array];
        for (int i = 0; i < numbers.count; i++) {
            NSNumber* element = [self getExtremeValueFromOneDimensionArray: numbers[i] isMax:isMax];
            if (element) [oneDmensionInnerArrayExtremeValues addObject: element];
        }
        compares = oneDmensionInnerArrayExtremeValues;
    }
    
    return [self getExtremeValueFromOneDimensionArray: compares isMax:isMax];
}

+(NSNumber*) getExtremeValueFromOneDimensionArray:(NSArray*)numbers isMax:(BOOL)isMax
{
    NSNumber* value = nil;
    for (int j = 0; j < numbers.count; j++) {
        NSNumber* element = [numbers objectAtIndex: j];
        double elementValue = [element doubleValue];
        
        if (! value) value = element;
        
        // get max
        if (isMax && [value doubleValue] < elementValue) {
            value = element ;
        }
        
        else
            
            // get min
            if (! isMax && [value doubleValue] > elementValue) {
                value = element;
            }
    }
    return value;
}

+(NSMutableArray*) getBaseTimesAccordingToViews: (NSArray*)views delay:(double)delay
{
    if (delay == 0) return nil;
    
    NSNumber* delayNum = @(delay);
    NSMutableArray* baseTimes = [NSMutableArray array];
    for (NSArray* innerViews in views) {
        NSMutableArray* innerBaseTimes = [NSMutableArray array];
        for (int i = 0; i < innerViews.count; i++) {
            [innerBaseTimes addObject:delayNum];
        }
        [baseTimes addObject: innerBaseTimes];
    }
    return baseTimes;
}





@end
