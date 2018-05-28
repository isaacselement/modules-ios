#import "PositionsExecutor.h"
#import "_ActionExecutor_.h"


@implementation PositionsExecutor


#pragma mark - Override Methods

// extend the transition.mode ... , call super and add 2
-(NSMutableArray*) applyTransitionMode: (NSDictionary*)config values:(NSArray*)values from:(int)fromIndex to:(int)toIndex
{
    NSMutableArray* transitionList = [super applyTransitionMode:config values:values from:fromIndex to:toIndex];
    
    int transitionMode = [config[@"transitionMode"] intValue];
    
    // skip , just jump to the turning point
    if (transitionMode == 2) {
        NSMutableArray* list = [NSMutableArray array];
        for (int j = fromIndex; j <= toIndex; j++) {
            [list addObject: [values objectAtIndex: j]];
        }
        NSMutableArray* newList = [self leavingTheTurningPoint: list];
        [transitionList setArray: newList];
    }
    
    return transitionList;
}

// cause value are CGPoint
-(id) getEasingValue: (NSArray*)transitions index:(int)index nextIndex:(int)nextIndex argument:(double)argument
{
    CGPoint point = [self getIndexValue:transitions index:index];
    CGPoint nextPoint = [self getIndexValue:transitions index:nextIndex];
    
    double positionX = point.x + (nextPoint.x - point.x) * argument;
    double positionY = point.y + (nextPoint.y - point.y) * argument;
    return [NSValue valueWithCGPoint: CGPointMake(positionX, positionY)];
}

-(CGPoint) getIndexValue:(NSArray*)transitions index:(int)index
{
    if (index < 0) {
        CGPoint a = [[transitions objectAtIndex: 0] CGPointValue];
        CGPoint b = [[transitions objectAtIndex: 1] CGPointValue];

//        double result = a + (a - b) * (0 - index);
        CGPoint result = CGPointMake(a.x + (a.x - b.x) * (0 - index), a.y + (a.y - b.y) * (0 - index));
        return result;
        
    } else if (index >= transitions.count) {
        CGPoint a = [[transitions objectAtIndex: transitions.count - 1] CGPointValue];
        CGPoint b = [[transitions objectAtIndex: transitions.count - 2] CGPointValue];
        
//        double result = a + (a - b) * (index - (transitions.count - 1));
        CGPoint result = CGPointMake(a.x + (a.x - b.x) * (index - (transitions.count - 1)), a.y + (a.y - b.y) * (index - (transitions.count - 1)));
        return result;
    }
    
    return [[transitions objectAtIndex:index] CGPointValue];
}


#pragma mark - Utilities Methods

-(NSMutableArray*) leavingTheTurningPoint: (NSMutableArray*)transtionList {
    float prevoiusRadians = 3.15;
    NSInteger count = transtionList.count;
    NSMutableArray* newTransition = [NSMutableArray arrayWithCapacity: 2];
    for (int i = 0; i < count-1; i++) {
        NSValue* value = [transtionList objectAtIndex: i] ;
        CGPoint point = [value CGPointValue];
        NSValue* nextValue = [transtionList objectAtIndex: i+1];
        CGPoint nextPoint = [nextValue CGPointValue] ;
        
        if (value == nextValue || CGPointEqualToPoint(point, nextPoint)) {
            [newTransition addObject: value];
        } else {
            float radians = atan2f(nextPoint.x - point.x , nextPoint.y - point.y);  // Get two points radian
            if (prevoiusRadians != radians) {
                [newTransition addObject: value];
                prevoiusRadians = radians;
            }
        }
    }
    [newTransition addObject: [transtionList lastObject]];
    return newTransition;
}

@end