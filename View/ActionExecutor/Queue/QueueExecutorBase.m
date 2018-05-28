#import "QueueExecutorBase.h"
#import "_ActionExecutor_.h"

#import "KeyValueHelper.h"
#import "QueueTimeCalculator.h"

#import "EaseFunction.h"


#define defaultStepTime 0.05

@implementation QueueExecutorBase

@synthesize delegate;

-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times {
    NSMutableArray* durations = [NSMutableArray array];
    NSMutableArray* beginTimes = [NSMutableArray array];
    
    
    // Empty ? We do not add the animation . But the Delegate should go on .
    if (objects.count) {
        
        
        NSNumber* stepTimeNum = [config objectForKey: @"stepTime"];
        double stepTime = stepTimeNum ? [stepTimeNum floatValue] : defaultStepTime;
        
        NSNumber* delayNumber = [config objectForKey: @"matrix_delayRelativeToMilestone"];
        int delayCount = delayNumber ? [delayNumber intValue] : 0;
        double delayTime = stepTime * delayCount;                   // A . the resutl we need first
        
        NSNumber* intervalNumber = [config objectForKey: @"matrix_delayRelativeToQueueIndex"];
        int eachInterval = intervalNumber ? [intervalNumber  intValue] : 0;
        
        
        // a queue, one dimension
        if (! [[objects firstObject] isKindOfClass: [NSArray class]]) {
            
            if (delayTime != 0 || eachInterval != 0) {
                
                NSMutableArray* newTimes = [NSMutableArray array];
                int count = (int)objects.count;
                for (int index = 0; index < count; index++) {
                    
                    int interval = eachInterval;
                    interval = interval < 0 ? abs(interval) * (count - index - 1) : interval * index;
                    double intervalTime = stepTime * interval;              // B . the resutl we need second
                    double incrementTime = intervalTime + delayTime;        // C . the resutl we need finally, we have to do is caculate the new baseTime values
                    
                    double oldTime = [[times safeObjectAtIndex:index] doubleValue];
                    double newTime = oldTime + incrementTime;
                    
                    [newTimes addObject:@(newTime)];
                    
                }
                
                times = newTimes;
                
            }
            
            [self execute: config objects:objects values:values times:times durationsRep:durations beginTimesRep:beginTimes];
            
        // a matrix, two dimension
        } else {
            
            
            int count = (int)objects.count;
            for (int index = 0; index < count; index++) {
                NSArray* innerTimes = [times safeObjectAtIndex: index];
                
                NSArray* innerObjects = [objects objectAtIndex: index];
                NSArray* innerValues = [values objectAtIndex: index];
                
                if (delayTime != 0 || eachInterval != 0) {
                    
                    int interval = eachInterval;
                    interval = interval < 0 ? abs(interval) * (count - index - 1) : interval * index;
                    double intervalTime = stepTime * interval;              // B . the resutl we need second
                    double incrementTime = intervalTime + delayTime;        // C . the resutl we need finally, we have to do is caculate the new baseTime values
                    
                    
                    NSMutableArray* newInnerTimes = [NSMutableArray array];
                    
                    for (NSUInteger j = 0; j < innerObjects.count; j++) {
                        
                        double oldTime = [[innerTimes safeObjectAtIndex: j] doubleValue];
                        double newTime = oldTime + incrementTime;
                        
                        [newInnerTimes addObject:@(newTime)];
                    }
                    
                    innerTimes = newInnerTimes;
                    
                }
                
                // for the return value
                NSMutableArray* innerDurations = [NSMutableArray array];
                NSMutableArray* innerBeginTimes = [NSMutableArray array];
                [durations addObject: innerDurations];
                [beginTimes addObject: innerBeginTimes];
                [self execute: config objects:innerObjects values:innerValues times:innerTimes durationsRep:innerDurations beginTimesRep:innerBeginTimes];
            }
        }
        
    }
    
    
    
    // Delegate
    if (delegate && [delegate respondsToSelector:@selector(queue:beginTimes:durations:)]) {
        [delegate queue: self beginTimes:beginTimes durations:durations];
    }
    
}

/*
 the last obj in objects will go to the position which is the last obj in values
 and the objects.count <= values.count , objects.count == baseTimes.count or baseTimes is nil
 */
-(void) execute: (NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times durationsRep:(NSMutableArray*)durationsQueue beginTimesRep:(NSMutableArray*)beginTimesQueue {
    if (objects.count == 0) return;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
    animation.delegate = (id<CAAnimationDelegate>)self;
    animation.keyPath = config[@"keyPath"];
    
    /*
     // About the relationship about fillMode & removedOnCompletion
     // IOS default is YES, when removedOnCompletion = NO , the fillMode would work.
     animation.removedOnCompletion = NO;
     // IOS default is kCAFillModeRemoved
     animation.fillMode = kCAFillModeForwards ;
     */
    NSDictionary* animationKeysValues = config[@"Animation"];
    [animation setValuesForKeysWithDictionary:animationKeysValues];
    NSNumber* repeatCountNum = animationKeysValues[@"repeatCount"];
    if (repeatCountNum) {
        float repeatCount = [repeatCountNum floatValue];
        animation.repeatCount = repeatCount < 0 ? HUGE_VALF : repeatCount;
    }
    
    int emptyIndividual = 0 ;
    int objectsCount = (int)objects.count;
    
    double stepTime = config[@"stepTime"] ? [config[@"stepTime"] floatValue] : defaultStepTime;
    float elementActivityOffset = [config[@"element_startingOffset"] floatValue];
    
    double totalTime = 0 ;
    BOOL isByTotalTime = NO;
    NSNumber* eTotalTransitTime = config[@"element_totalTransitTime"];
    if (eTotalTransitTime) {
        totalTime = [eTotalTransitTime doubleValue] ;
        isByTotalTime = YES;
    }
    double intervalUnitTime = isByTotalTime ? totalTime : stepTime;
    
    BOOL isLeaveEmpty = [config[@"queue_isLeaveEmpty"] boolValue];
    
    
    for (int i = objectsCount - 1; i >= 0; i--) {
        CALayer* layer = [objects objectAtIndex: i];
        if ([layer isKindOfClass: [UIView class]]) layer = ((UIView*)layer).layer;

        if (![layer isKindOfClass: [CALayer class]]) {
            if (!isLeaveEmpty) emptyIndividual++ ;
            [durationsQueue addObject: @(0)];
            [beginTimesQueue addObject: @(0)] ;
            continue ;
        }
        
        NSArray* transitionValues = values ? values : [self translateConfigValues:config[@"values"] layer:layer keyPath:animation.keyPath];
        int objectsValuesOffset = (int)transitionValues.count - objectsCount;
        
        // set the animation values
        NSMutableArray* transitionList = [self applyTransitionMode: config values:transitionValues from:i to:i + objectsValuesOffset + emptyIndividual];
        NSMutableArray* animationValues = [self applyValuesEasing: config transitions:transitionList];
        animation.values = animationValues;

        
        int valuesCount = (int)animation.values.count;
        
        // after set values , set duration
        int interval = elementActivityOffset < 0 ? i : (objectsCount - 1 - i - emptyIndividual);
        double intervalTime = interval * (intervalUnitTime * fabsf(elementActivityOffset));                 // a
        double inactivityTime = [[times safeObjectAtIndex: i] doubleValue];                                 // b
        
        // caculate the inactivityDuration & activityDuration, then get the durateion
        double inactivityDuration = inactivityTime + intervalTime;                                          // c = a + b
        double activityDuration = isByTotalTime ? totalTime : (valuesCount == 0 ? stepTime : stepTime * (valuesCount - 1));      // d
        double animationDuration = inactivityDuration + activityDuration ;                                  // animation.duration = c + d
        animation.duration = animationDuration;
        
        
        // after set values and duration , set keyTimes
        float activityRatio = activityDuration / animationDuration;
        float inactivityRatio = inactivityDuration / animationDuration;
        NSMutableArray* keyTimes = [self getKeyTimes: valuesCount activityRatio:activityRatio inactivityRatio:inactivityRatio];
        animation.keyTimes = keyTimes;
        
        
        // after the keyTimes over, set the timing easing
        [self applyTimingsEasing: config animation:animation];
        
        
        // after set values, before add animation to the layer, set the final status
        BOOL forward = [config[@"forward"] boolValue];
        if (forward) {
            // Update the property in advance . After update the property , then apply animation to layer
            [layer setValue:[animation.values lastObject] forKeyPath:animation.keyPath];
        }
        
        
        // finally, add the animation to the layer.
        [self applyAnimation:animation layer:layer config:config];
        
        
        // transfer time value to outside
        // beginTimes
        [beginTimesQueue addObject: [NSNumber numberWithDouble: inactivityDuration]];
        // durations
        double totalDuration = animation.duration;
        totalDuration = animation.autoreverses ? totalDuration * 2: totalDuration;
        totalDuration = animation.repeatCount > 0 ? totalDuration * animation.repeatCount : totalDuration;
        totalDuration = animation.repeatDuration > 0 ? animation.repeatDuration : totalDuration;            // after repeatCount
        totalDuration = totalDuration / animation.speed;
        [durationsQueue addObject: [NSNumber numberWithDouble: totalDuration]];
    }
}
 

#pragma mark - Private Methods

-(NSMutableArray*) applyValuesEasing: (NSDictionary*)config transitions:(NSMutableArray*)transitions {
    if (! transitions || transitions.count <= 1) return transitions;
    
    EasingType easeType = [[config objectForKey: @"queue_easingType"] intValue];
    NSKeyframeAnimationFunction easeFunction = [EaseFunction easingFunctionForType: easeType];
    if (! easeFunction) return transitions;
    
    int listCount = (int)transitions.count;
    int degree = listCount - 1 ;
    NSNumber* qEasingDegree = config[@"queue_easingDegree"];
    if (qEasingDegree) {
        int steps = [qEasingDegree intValue];
        if (steps > degree) degree = steps;
    }
    
    // https://github.com/AttackOnDobby/iOS-Core-Animation-Advanced-Techniques/blob/master/10-%E7%BC%93%E5%86%B2/%E7%BC%93%E5%86%B2.md
    // caculate the Easing Argument --- Begin
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity: degree];
    const double increment = 1.0 / (double)(degree - 1);
    double progress = 0.0, argument = 0.0;
    double t = 0 ,b = 0 , c = 1 , d = 1 ;
    for (int i = 0; i <= degree; i++) {
        t = (double)i/degree ;
        argument = easeFunction(t, b, c, d) ;
        [arguments addObject: [NSNumber numberWithDouble: argument]];
        progress += increment;
    }
    // caculate the Easing Argument --- End
    
    
    // base on the argument, caculate the easing value --- Begin
    NSMutableArray* newTransitions = [NSMutableArray array];
    int segments = listCount - 1;
    float averageSegment = 1.0 / segments ;
    
    for (int i = 0; i < arguments.count; i++) {
        double argument = [arguments[i] doubleValue];
        int index = argument / averageSegment ;
        int nextIndex = (index == segments) ? segments : index + 1;
        
        id easingValue = [self getEasingValue:transitions index:index nextIndex:nextIndex argument:argument];
        
        [newTransitions addObject: easingValue];
    }
    // base on the argument, caculate the easing value --- End
    
    return newTransitions;
}


// need the animation values was set
-(NSMutableArray*) getKeyTimes: (int)animationValuesCount activityRatio:(float)activityRatio inactivityRatio:(float)inactivityRatio {
    if (animationValuesCount == 0 || animationValuesCount == 1) return nil;
    
    int count = animationValuesCount - 1;
    float activityRatioUnitRate = activityRatio / count;
    NSMutableArray* keyTimes = [NSMutableArray array];
    for (int p = 0; p < count; p++) {
        [keyTimes addObject: [NSNumber numberWithFloat: inactivityRatio + activityRatioUnitRate * p]];
    }
    // here , i make sure the last one value is 1.0
    [keyTimes addObject: [NSNumber numberWithFloat: 1.0]];
    return keyTimes;
}

// when controll each , should after setKeyTimes (need the keyTimes was set)
-(void) applyTimingsEasing: (NSDictionary*)config animation:(CAKeyframeAnimation*)animation
{
    NSArray* timing = config[@"queue_timingFunction"];
    if (timing) {
        float c1x = [[timing safeObjectAtIndex:0] floatValue];
        float c1y = [[timing safeObjectAtIndex:1] floatValue];
        float c2x = [[timing safeObjectAtIndex:2] floatValue];
        float c2y = [[timing safeObjectAtIndex:3] floatValue];
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints: c1x :c1y :c2x :c2y];
    }
    
    NSArray* timings = config[@"queue_keyTimesFunctions"];
    if (timings) {
        float c1x = [[timings safeObjectAtIndex:0] floatValue];
        float c1y = [[timings safeObjectAtIndex:1] floatValue];
        float c2x = [[timings safeObjectAtIndex:2] floatValue];
        float c2y = [[timings safeObjectAtIndex:3] floatValue];
        
        NSUInteger count = animation.keyTimes.count;
        NSMutableArray* timingFunctions = [NSMutableArray arrayWithCapacity: count];
        for (NSUInteger i = 0; i < count - 1 ; i++ ) {
            [timingFunctions addObject: [CAMediaTimingFunction functionWithControlPoints: c1x :c1y :c2x :c2y]];
        }
        animation.timingFunctions = timingFunctions;
    }
}


-(NSMutableArray*) translateConfigValues:(NSArray*)values layer:(CALayer*)layer keyPath:(NSString*)keyPath
{
    NSMutableArray* results = [NSMutableArray array];
    NSDictionary* propertiesTypes = [KeyValueHelper getClassPropertieTypes: [layer class]];
    NSString* keyPathType = propertiesTypes[keyPath];
    for (NSUInteger i = 0; i < values.count; i++) {
        id value = values[i];
        id newValue = [[KeyValueHelper sharedInstance] translateValue:value type:keyPathType object:layer keyPath:keyPath];
        [results addObject:newValue];
    }
    return results.count ? results : nil;
}


#pragma mark - Subclass Optional Override Methods

-(NSMutableArray*) applyTransitionMode: (NSDictionary*)config values:(NSArray*)values from:(int)fromIndex to:(int)toIndex
{
    if (! values) return nil;
    
    NSMutableArray* transitionList = [NSMutableArray array];
    
    int transitionMode = [config[@"transitionMode"] intValue];
    
        // iterate, just iterate all the values
    if (transitionMode == -1) {
        
        [transitionList setArray: values];
        
        // roll , default, go to its own values
    } else if (transitionMode == 0) {
        
        for (int index = fromIndex; index <= toIndex; index++) {
            [transitionList addObject: values[index]];
        }
        
        // rain , jump from begin to final directly
    } else if(transitionMode == 1) {
        
        [transitionList setArray:@[values[fromIndex], values[toIndex]]];
        
    }
    
    return transitionList;
}


-(id) getEasingValue: (NSArray*)transitions index:(int)index nextIndex:(int)nextIndex argument:(double)argument
{
    double value = [self getIndexValue:transitions index:index];
    double nextValue = [self getIndexValue:transitions index:nextIndex];
    
    double result = value + (nextValue - value) * argument;
    return [NSNumber numberWithDouble: result];
}
-(double) getIndexValue:(NSArray*)transitions index:(int)index
{
    if (index < 0) {
        double a = [[transitions objectAtIndex: 0] doubleValue];
        double b = [[transitions objectAtIndex: 1] doubleValue];
        double result = a + (a - b) * (0 - index);
        return result;
    } else if (index >= transitions.count) {
        double a = [[transitions objectAtIndex: transitions.count - 1] doubleValue];
        double b = [[transitions objectAtIndex: transitions.count - 2] doubleValue];
        double result = a + (a - b) * (index - (transitions.count - 1));
        return result;
    }
    
    return [[transitions objectAtIndex:index] doubleValue];
}


-(void) applyAnimation: (CAKeyframeAnimation*)animation layer:(CALayer*)layer config:(NSDictionary*)config
{
    [layer removeAnimationForKey: animation.keyPath];
    [layer addAnimation: animation forKey:animation.keyPath];
}





#pragma mark - CAAnimationDelegate

//#ifdef DEBUG
//static NSDate* startTime;
//#endif
- (void)animationDidStart:(CAAnimation *)anim
{
    // Deleagate
    if (delegate && [delegate respondsToSelector:@selector(queueDidStart:animation:)]) {
        [delegate queueDidStart: self animation:anim];
    }
    
//#ifdef DEBUG
//    startTime = [NSDate date];
//#endif
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // Delegate
    if (delegate && [delegate respondsToSelector:@selector(queueDidStop:animation:finished:)]) {
        [delegate queueDidStop: self animation:anim finished:flag];
    }
    
//#ifdef DEBUG
//    NSLog(@"animationDidStop Duration: %f", [[NSDate date] timeIntervalSinceDate: startTime]);
//#endif
}

@end
