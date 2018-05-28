#import "ActionExecutorBase.h"

@class CAAnimation;
@class QueueExecutorBase;

@protocol QueueExecutorDelegate <NSObject>

-(void)queue:(QueueExecutorBase*)executor beginTimes:(NSArray*)beginTimes durations:(NSArray*)durations;

-(void)queueDidStart:(QueueExecutorBase*)executor animation:(CAAnimation *)anim;

-(void)queueDidStop:(QueueExecutorBase*)executor animation:(CAAnimation *)anim finished:(BOOL)flag;

@end





@interface QueueExecutorBase : ActionExecutorBase

@property (strong) id<QueueExecutorDelegate> delegate;

#pragma mark - Optional Override Methods

// now for ElementsExecutor
-(void) execute: (NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times durationsRep:(NSMutableArray*)durationsQueue beginTimesRep:(NSMutableArray*)beginTimesQueue;





// Like 'skip' in PositionExectutor
-(NSMutableArray*) applyTransitionMode: (NSDictionary*)config values:(NSArray*)values from:(int)fromIndex to:(int)toIndex;

// CGPoint 's easing value is judge by point.x and point.y in PositionExectutor
-(id) getEasingValue: (NSArray*)transitions index:(int)index nextIndex:(int)nextIndex argument:(double)argument;



// now for the ExplodesExecutor
-(void) applyAnimation: (CAKeyframeAnimation*)animation layer:(CALayer*)layer config:(NSDictionary*)config;

@end
